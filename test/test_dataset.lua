require 'torchlib'

local TestSplit = {}
local tester

local eps = 1e-5

local function makeSplit()
  local x = (torch.rand(3, 2)*10):int()
  local y = torch.IntTensor{1, 3, 2}
  local mask = torch.IntTensor{{1, 1, 0}, {1, 0, 0}, {1, 1, 1}}
  local s = Split.new(x, y, mask)
  return x, y, mask, s
end

function TestSplit.testNew()
  local x, y, mask, s = makeSplit()
  tester:assertTensorEq(x, s.X, eps)
  tester:assertTensorEq(y, s.Y, eps)
  tester:assertTensorEq(mask, s.mask, eps)
end

function TestSplit.testFromTable()
  local x = {(torch.rand(2)*10):int(), (torch.rand(3)*10):int(), (torch.rand(1)*10):int()}
  local y = {1, 3, 2}
  local max_len = 2
  local s = Split.fromTable(x, y, 2)

  local xe = torch.zeros(2, 2):int()
  xe[1] = x[1]
  xe[2][1] = x[3]
  local ye = torch.IntTensor{1, 2}
  local mask = torch.IntTensor{{1, 1}, {1, 0}}

  tester:assertTensorEq(s.X, xe, eps)
  tester:assertTensorEq(s.Y, ye, eps)
  tester:assertTensorEq(s.mask, mask, eps)
end

function TestSplit.testShuffle()
  local x, y, mask, s = makeSplit()
  local xo, yo, mo = x:clone(), y:clone(), mask:clone()
  local perm = s:shuffle()
  for i = 1, perm:size(1) do
    local old = perm[i]
    tester:assertTensorEq(s.X[i], xo[old], eps)
    tester:asserteq(s.Y[i], yo[old], eps)
    tester:assertTensorEq(s.mask[i], mo[old], eps)
  end
end

function TestSplit.testKfold()
  local x, y, mask, s = makeSplit()
  local folds = s:kfold(2)
  local exp = torch.IntTensor{{1, 2}, {3, 3}}
  tester:assertTensorEq(folds, exp, eps)
end

function TestSplit.testSplitFold()
  local x, y, mask, s = makeSplit()
  local train, test = s:splitFold(torch.IntTensor{1, 2})
  tester:asserteq(train:size(), 1)
  tester:assertTensorEq(train.X[1], x[3], eps)
  tester:asserteq(test:size(), 2)
  tester:assertTensorEq(test.X[1], x[1], eps)
  tester:assertTensorEq(test.X[2], x[2], eps)

  train, test = s:splitFold(torch.IntTensor{3, 3})
  tester:asserteq(train:size(), 2)
  tester:assertTensorEq(train.X[1], x[1], eps)
  tester:assertTensorEq(train.X[2], x[2], eps)
  tester:asserteq(test:size(), 1)
  tester:assertTensorEq(test.X[1], x[3], eps)

  train, test = s:splitFold(torch.IntTensor{2, 2})
  tester:asserteq(train:size(), 2)
  tester:assertTensorEq(train.X[1], x[1], eps)
  tester:assertTensorEq(train.X[2], x[3], eps)
  tester:asserteq(test:size(), 1)
  tester:assertTensorEq(test.X[1], x[2], eps)

end

tester = torch.Tester()
tester:add(TestSplit)
tester:run()
