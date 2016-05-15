local optim = require 'optim'
local nn = require 'nn'
local xlua = require 'xlua'
local Dataset = tl.Dataset
local pretty = require 'pl.pretty'
local tablex = require 'pl.tablex'
local path = require 'pl.path'
local dir = require 'pl.dir'
local torch = require 'torch'

--- @module Model
-- Implementation of model abstract class.
-- 
-- The idea of this class is to provide a standard interface for training/evaluating models and help avoid duplication of code.
-- It is set up in a modular fashion such that a model can overwrite key components of the training process (eg. the actual
-- implementation of the network via `get_net`, the criterion via `get_criterion`, how batches from the dataset are preprocessed
-- via `process_batch`).
-- 
-- Example:
-- 
-- @code {lua}
-- local MyModel = torch.class('MyModel', 'tl.Model')
-- 
-- function MyModel:required_params()
--   return {'d_in', 'd_hid'}
-- end
-- 
-- function MyModel:get_net()
--   return nn.Sequential()
--       :add(nn.Linear(self.opt.d_in, self.opt.d_hid))
--       :add(nn.Tanh())
--       :add(nn.Linear(self.opt.d_hid, 1))
-- end
-- 
-- function MyModel:get_criterion()
--   return nn.MSECriterion()
-- end
local Model = torch.class('tl.Model')

--- Constructor.
-- @arg {table} opt - a key-value map of parameters for the model.
-- 
-- If you feel the need to have a more specific constructor, you should add to the 
-- implementation of the child class. In practice, it is often sufficient to overwrite
-- the functions `get_net`, `get_criterion`, and `initialize`
function Model:__init(opt)
  self.opt = opt or {}
  for _, p in ipairs(self:required_params()) do
    assert(self.opt[p], 'missing required parameter '..p)
  end

  self.net = self:get_net()
  self.criterion = self:get_criterion()
  self.params, self.dparams = self.net:getParameters()
  self:initialize()
end

--- Initializes the model.
-- By default, uniformly initializes all parameters to between -0.08 and 0.08 and resets gradients to 0.
-- @returns {Model} initialized model
function Model:initialize()
  self.params:uniform(-0.08, 0.08)
  self.dparams:zero()
  return self
end

--- @returns {table} required arguments for the constructor
--
-- By default returns empty table. If a required argument is not met, then the constructor will abort with an error.
function Model:required_params()
  return {}
end

--- @returns {torch.Module} implementation of the network.
--
-- Note: You must overwrite this function.
function Model:get_net()
  error('not implemented')
end

--- @returns {torch.Module} implementation of the network.
--
-- By default returns `nn.CrossEntropyCriterion()`.
function Model:get_criterion()
  return nn.CrossEntropyCriterion()
end

--- Applies prepocessing to the batch object returned by `Dataset.batches`.
-- @arg {table[string:table]} batch - a map from `Dataset.batches`
-- @arg {int} pad - what to use to pad variably lengthed examples in `batch.X`.
-- @returns {table[string:table]} padded batch
-- 
-- By default, this pads the `X` field using `Dataset.pad` and converts the `Y` field to a `Tensor`.
-- You may want to do different things here, such as convert tensors to CUDA, pad a different field etc.
function Model:process_batch(batch, pad)
  batch.X = Dataset.pad(batch.X, pad)
  batch.Y = torch.Tensor(batch.Y)
  return batch
end

--- Trains on a `Dataset` instance.
-- 
--  @arg {Dataset} dataset - dataset to train on.
--  @arg {table} opt - training options
--  @arg {optim.optimizer=optim.adam} optimize - optimizer for training
--  @arg {table=} optim_opt - optimizer options
--  @returns {number} average loss per example
--
--  `opt` specifies:
-- 
--     - `batch_size`: the number of examples per batch to fetch from `dataset`. By default this is `128`.
-- 
--     - `silent`: whether to prevent progress updates (eg. via a progress bar). By default this is `false`.
-- 
--     - `pad`: The integer used for padding variable lengthed sequences. By default this is `0`.
-- 
--  Example:
-- 
--  @code {lua}
--  d = Dataset{X = X, Y = Y}
--  loss = model:train(d, {silent=true, batch_size=10}, optim.adam, {learningRate=1e-3})
function Model:train(dataset, opt, optimize, optim_opt)
  opt = opt or {}
  opt.batch_size = opt.batch_size or 128
  opt.silent = opt.silent or false
  opt.pad = opt.pad or 0
  optimize = optimize or optim.adam
  optim_opt = optim_opt or {}
  optim_opt.learningRate = optim_opt.learningRate or 1e-3

  self.net:training()

  local x, y
  self.feval = self.feval or function(params)
    if params ~= self.params then self.params:copy(params) end
    self.dparams:zero()
    local scores = self.net:forward(x)
    local loss = self.criterion:forward(scores, y)
    local dscores = self.criterion:backward(scores, y)
    self.net:backward(x, dscores)
    return loss, self.dparams
  end

  local loss, ret, _ = 0
  for batch, batch_end in dataset:batches(opt.batch_size) do
    batch = self:process_batch(batch, opt.pad)
    x, y = batch.X, batch.Y
    _, ret = optimize(self.feval, self.params, {learningRate = opt.lr})
    loss = loss + ret[1] * x:size(1)
    if not opt.silent then xlua.progress(batch_end, dataset:size()) end
  end

  return loss / dataset:size()
end

--- Evaluates on a `Dataset` instance.
-- 
-- @arg {Dataset} dataset - dataset to evaluate on
-- @arg {table} opt - evaluation options
-- @returns {number, torch.Tensor, torch.Tensor, torch.Tensor, torch.Tensor} evaluation results
-- 
-- `opt` specifies:
-- 
--    - `batch_size`: the number of examples per batch to fetch from `dataset`. By default this is `128`.
-- 
--    - `silent`: whether to prevent progress updates (eg. via a progress bar). By default this is `false`.
-- 
--    - `pad`: The integer used for padding variable lengthed sequences. By default this is `0`.
-- 
-- Returns the following:
-- 
-- - `loss`: average loss per example
-- 
-- - `pred`: a `Tensor` contintaing the predictions made
-- 
-- - `targ`: a `Tensor` contintaing the ground truth
-- 
-- - `max_scores`: a `Tensor` contintaing the max scores for each prediction
-- 
-- - `raw_scores`: a `Tensor` contintaing the raw scores for each prediction
-- 
-- Example:
-- 
-- @code {lua}
-- d = Dataset{X = X, Y = Y}
-- loss, pred, targ, max_scores, raw_scores = model:evaluate(d, {silent=true, batch_size=10})
function Model:evaluate(dataset, opt)
  opt = opt or {}
  opt.batch_size = opt.batch_size or 128
  opt.silent = opt.silent or false
  opt.pad = opt.pad or 0

  self.net:evaluate()

  local loss, scores, targs, x, y = 0, {}, {}
  for batch, batch_end in dataset:batches(opt.batch_size) do
    batch = self:process_batch(batch, opt.pad)
    x, y = batch.X, batch.Y
    targs = table.extend(targs, y:totable())
    scores = table.extend(scores, self.net:forward(x):totable())
    loss = loss + self.criterion:forward(self.net.output, y) * x:size(1)
    if not opt.silent then xlua.progress(batch_end, dataset:size()) end
  end

  targs = torch.Tensor(targs)
  scores = torch.Tensor(scores)
  local max_scores, preds = scores:max(2)
  return {
    loss = loss / dataset:size(),
    pred = preds:squeeze(),
    targ = targs:squeeze(),
    max_scores = max_scores:squeeze(),
    raw_scores = scores,
  }
end


--- Trains and evaluates a model.
--  @arg {table[string:Dataset]} dataset - a map of datasets
--  @arg {table=} opt - training options
--  @arg {table[string:function]=} callbacks - a map of callback functions that are run after each epoch.
--  @arg {function=} progress - returns whether this epoch is an improvement over the best results seen so far
--  @arg {optim.optimizer=optim.adam} optim - optimizer for `train`
--  @arg {table=} optim_opt - optimizer options for `train`
--  @returns {table, table} best evaluation results seen during training and the training history of all evaluation results.
--
--  `dataset` contains:
--
--    - `train`: the `Dataset` to train on.
--
--    - `dev`: the development `Dataset` to evaluate on. Used for early stopping
--
--    - `test`: the `Dataset` to test on. Optional. If specified, then will be evaluated on at the end of training.
--
-- `opt` contains:
--
--    - `batch_size`: the number of examples per batch to fetch from `dataset`. By default this is `128`.
--
--    - `silent`: whether to prevent progress updates (eg. via a progress bar). By default this is `false`.
--
--    - `patience`: the number of sub-optimal epochs to tolerate before early stopping. Default is `5`.
--
--    - `n_epoch`: the maximum number of epochs to train for. Default is `30`.
--
--    - `save`: where to save progress. If not specified then no saving will be done.
--
-- `callbacks` functions take the following arguments:
--
--    - `split`: the name of the split being run
--
--    - `res`: the evaluation results for the split
--
--  If a callback returns values, then the values will be stored in the evaluation results for that epoch
--  and printed to stdout.
--
-- `progress` takes a function that takes as arguments:
--
--    - `curr`: the evaluation results for the current epoch
--
--    - `best`: the best evaluation result so far
--
--  and returns whether `curr` is better than `best`. By default, this compares the `loss` field.
--
-- @code {lua}
-- d = {
--   train=Dataset{X = Xtrain, Y = Ytrain}, 
--   dev=Dataset{X = Xdev, Y = Ydev}, 
--   test=Dataset{X = Xtest, Y = Ytest}, 
-- }
-- best_scores, train_hist = model:fit(d, {silent=true, batch_size=10})
function Model:fit(dataset, opt, callbacks, progress, optim, optim_opt)
  assert(dataset)
  assert(dataset.train)
  assert(dataset.dev)
  opt = opt or {}
  opt.batch_size = opt.batch_size or 128
  opt.silent = opt.silent or false
  opt.patience = opt.patience or opt.patience or 5
  opt.n_epoch = opt.n_epoch or 30
  opt.save = opt.save or nil
  progress = progress or function(curr, best) return curr.dev.loss < best.dev.loss end
  callbacks = callbacks or {}

  local hist, patience, best = {}, 0
  local best_params = self.params:clone()

  local save = function(epoch)
    epoch = epoch or ''
    if opt.save then
      if not path.isdir(opt.save) then dir.makepath(opt.save) end
      pretty.dump(opt, path.join(opt.save, 'opt.json'))
      pretty.dump(hist, path.join(opt.save, 'hist.json'))
      pretty.dump(best, path.join(opt.save, 'best.json'))
      torch.save(path.join(opt.save, 'params'..epoch..'.t7'), self.params:float())
    end
  end

  local announce = function(str)
    if not opt.silent then print(str) end
  end

  for epoch = 1, opt.n_epoch do
    local stats = {epoch=epoch, train={}, dev={}}
    collectgarbage()
    dataset.train:shuffle()
    announce('epoch '..epoch)
    self:train(dataset.train, opt, optim, optim_opt)

    for _, split in ipairs{'train', 'dev'} do
      local res = self:evaluate(dataset[split], opt)
      stats[split].loss = res.loss
      for name, func in pairs(callbacks) do
        stats[split][name] = func(split, res)
      end
    end
    stats.train.dparam_norm = self.dparams[self.dparams:ne(0)]:norm(2)

    if not best or progress(stats, best) then
      announce('found new best!')
      best = tablex.deepcopy(stats)
      patience = opt.patience
      best_params:copy(self.params)
      save()
    else
      patience = patience - 1
    end
    stats.patience = patience

    announce(pretty.write(stats))
    hist[epoch] = stats

    if opt.patience > 0 and patience == 0 then
      announce('early stopping triggered!')
      break
    end
  end

  self.params:copy(best_params)

  if dataset.test then
    local res = self:evaluate(dataset.test, opt)
    best.test = {loss = res.loss}
    for name, func in pairs(callbacks) do
      best.test[name] = func('test', res)
    end
  end
  announce('best score')
  announce(pretty.write(best))
  save()

  return best, hist
end

return Model
