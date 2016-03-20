require 'torchlib'

local TestDataset = torch.TestSuite()
local tester = torch.Tester()

local eps = 1e-5

local torch = require 'torch'
local T = torch.Tensor

-- seed the shuffling
torch.manualSeed(12)

function TestDataset.test_conll()
  local d = Dataset.from_conll('test/mock/conll.mock')
  tester:asserteq(3, d:size())
  tester:asserteq(3, #d.name)
  tester:assertTableEq({'Adam', 'Bob', 'Carol'}, d.name[1])
  tester:assertTableEq({'A', 'B', 'C'}, d.grade[1])
  tester:assertTableEq({'Zack', 'Yasmin', 'Xavier'}, d.name[2])
  tester:assertTableEq({'Z', 'Y', 'X'}, d.grade[2])
  tester:assertTableEq({'Wesley', 'Victor'}, d.name[3])
  tester:assertTableEq({'W', 'V'}, d.grade[3])
  tester:assertTableEq({'class1', 'class2', 'class3'}, d.label)
end

local X = {T{1, 2, 3}, T{2, 3}, T{1, 3, 5, 2}}
local Y = {2, 5, 1}

local toyDataset = function()
  return Dataset{X=Util.tableCopy(X), Y=Util.tableCopy(Y)}
end

function TestDataset.test_shuffle()
  local d = toyDataset()
  d:shuffle()
  tester:assert(not Util.tableEquals(d.X, X))
  for _, t in ipairs(X) do
    tester:assert(Util.tableContains(d.X, t))
  end
end

function TestDataset.test_pad()
  local padded = Dataset.pad(X)
  tester:assertTableEq(T{0, 1, 2, 3}:totable(), padded[1]:totable())
  tester:assertTableEq(T{0, 0, 2, 3}:totable(), padded[2]:totable())
  tester:assertTableEq(T{1, 3, 5, 2}:totable(), padded[3]:totable())
end

function TestDataset.test_kfolds()
  local d = toyDataset()
  local folds = d:kfolds(3)
  tester:asserteq(3, #folds)
  local n = 0
  for _, fold in ipairs(folds) do
    n = n + #fold
  end
  tester:asserteq(d:size(), n)
end

function TestDataset.test_view()
  local d = toyDataset()
  local dd = d:view({1, 3})
  tester:asserteq(2, dd:size())
  tester:assertTableEq(d.X[1]:totable(), dd.X[1]:totable())
  tester:assertTableEq(d.X[3]:totable(), dd.X[2]:totable())
  local a, b = d:view({1, 3}, {3, 2, 3})
  tester:assertTableEq(d.X[1]:totable(), a.X[1]:totable())
  tester:assertTableEq(d.X[3]:totable(), a.X[2]:totable())
  tester:assertTableEq(d.X[3]:totable(), b.X[1]:totable())
  tester:assertTableEq(d.X[2]:totable(), b.X[2]:totable())
  tester:assertTableEq(d.X[3]:totable(), b.X[3]:totable())
end

function TestDataset.test_train_dev_split()
  local d = toyDataset()
  local train, test = d:train_dev_split{1, 3}
  tester:asserteq(2, train:size())
  tester:assertTableEq(d.X[1]:totable(), train.X[1]:totable())
  tester:assertTableEq(d.X[3]:totable(), train.X[2]:totable())
  tester:asserteq(1, test:size())
  tester:assertTableEq(d.X[2]:totable(), test.X[1]:totable())
end

function TestDataset.test_batches()
  local d = toyDataset()
  local i = 1
  for batch, batch_end in d:batches(2) do
    local p = require 'pl.pretty'
    if i == 1 then
      tester:assertTableEq(T{{1, 2, 3}, {0, 2, 3}}:totable(), Dataset.pad(batch.X):totable())
      tester:assertTableEq(T{2, 5}:totable(), batch.Y)
      tester:asserteq(2, batch_end)
    end
    if i == 2 then
      tester:assertTableEq(T{{1, 3, 5, 2}}:totable(), Dataset.pad(batch.X):totable())
      tester:assertTableEq({1}, batch.Y)
      tester:asserteq(3, batch_end)
    end
    i = i + 1
  end
end

function TestDataset.test_single_batch()
  local d = toyDataset()
  local i = 1
  for batch, batch_end in d:batches(1) do
    tester:assertTableEq({X[i]:totable()}, Dataset.pad(batch.X):totable())
    tester:assertTableEq({Y[i]}, batch.Y)
    tester:asserteq(batch_end, i)
    i = i + 1
  end
end

tester:add(TestDataset)
tester:run()
