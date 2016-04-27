local Model = require('torchlib').Model
local Dataset = require('torchlib').Dataset
local util = require('torchlib').util
local optim = require 'optim'

local TestModel = torch.TestSuite()
local tester = torch.Tester()

local eps = 1e-5

local torch = require 'torch'
local T = torch.Tensor

-- seed the shuffling
torch.manualSeed(12)

local MyModel = torch.class('MyModel', 'tl.Model')

function MyModel:required_params()
  return {'d_in', 'd_hid'}
end

function MyModel:get_net()
  return nn.Sequential()
      :add(nn.Linear(self.opt.d_in, self.opt.d_hid))
      :add(nn.Tanh())
      :add(nn.Linear(self.opt.d_hid, 1))
end

function MyModel:get_criterion()
  return nn.MSECriterion()
end

local get_dataset = function(n)
  n = n or 100
  local fields = {X={}, Y={}}
  for i = 1, n do
    fields.X[i] = torch.rand(2)
    fields.Y[i] = fields.X[i][1] * 2 + fields.X[i][2]
  end
  return Dataset(fields)
end

function TestModel.test_init()
  -- init while missing required parameter
  tester:assertErrorPattern(function() MyModel.new() end, 'missing required parameter d_in')
  tester:assertErrorPattern(function() MyModel.new{d_in=1} end, 'missing required parameter d_hid')

  local model = MyModel.new{d_in=2, d_hid=10}
  tester:asserteq('nn.Linear', torch.type(model.net.modules[1]))
  tester:asserteq('nn.Tanh', torch.type(model.net.modules[2]))
  tester:asserteq('nn.Linear', torch.type(model.net.modules[3]))
  tester:asserteq('nn.MSECriterion', torch.type(model.criterion))

  tester:assertge(0.08, model.params:min())
  tester:assertle(-0.08, model.params:max())
  tester:assert(model.dparams:eq(0):any())
end

function TestModel.test_train()
  torch.manualSeed(12)
  local model = MyModel.new{d_in=2, d_hid=10}
  local dataset = get_dataset(100)
  local opt, optimize, optim_opt
  opt = {batch_size=128, silent=true, pad=0}
  optimize = optim.adam
  optim_opt = {learningRate = 1e-3}
  -- hardcoded check
  tester:assertGeneralEq(2.2879896, model:train(dataset, opt, optimize, optim_opt), 1e-5)
end

function TestModel.test_evaluate()
  torch.manualSeed(12)
  local model = MyModel.new{d_in=2, d_hid=10}
  local dataset = get_dataset(100)
  opt = {batch_size=128, silent=true, pad=0}
  local ret = model:evaluate(dataset, opt)
  tester:assertGeneralEq(2.2879896, ret.loss, 1e-5)
  tester:asserteq(100, ret.pred:size(1))
  tester:asserteq(100, ret.targ:size(1))
  tester:asserteq(100, ret.max_scores:size(1))
  tester:asserteq(100, ret.raw_scores:size(1))
  tester:asserteq(1, ret.raw_scores:size(2))
end

function TestModel.test_fit()
  torch.manualSeed(12)
  local counter = {}
  local callbacks = {
    counter = function(split, res)
      counter[split] = (counter[split] or 0) + 1
      return counter[split]
    end,
    res_check = function(split, res)
      tester:assert(res.loss ~= nil)
    end
  }
  local model = MyModel.new{d_in=2, d_hid=3}
  local dataset = {train=get_dataset(100), dev=get_dataset(20), test=get_dataset(10)}
  local opt, optimize, optim_opt
  opt = {batch_size=2, silent=true, pad=0, n_epoch=10}
  optimize = optim.adam
  optim_opt = {learningRate = 1e-2}
  local best = model:fit(dataset, opt, callbacks)
  tester:assertGeneralEq(0.2101357, best.dev.loss, 1e-5)
  tester:assertGeneralEq(0.2766255, best.train.loss, 1e-5)
  tester:assertGeneralEq(0.3989304, best.test.loss, 1e-5)
  tester:asserteq(opt.n_epoch, counter.train)
  tester:asserteq(opt.n_epoch, counter.dev)
  tester:asserteq(1, counter.test)
end

tester:add(TestModel)
tester:run()
