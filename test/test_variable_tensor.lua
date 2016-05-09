local VariableTensor = require('torchlib').VariableTensor

local TestVariableTensor = torch.TestSuite()
local tester = torch.Tester()

math.randomseed(123)

function TestVariableTensor.testInit()
  local s = VariableTensor({preinit_size=3, preinit_store_size=5})
  tester:asserteq(3, s.indices:size(1))
  tester:asserteq(5, s.store:size(1))
end

function TestVariableTensor.testSize()
  local s = VariableTensor()
  tester:asserteq(s:size(), 0)
  s = VariableTensor({preinit_size=3, preinit_store_size=5})
  tester:asserteq(s:size(), 0)
end

function TestVariableTensor:testBatch()
  local s = VariableTensor()
  local a = torch.rand(5)
  local b = torch.rand(10)
  local c = torch.rand(7)
  local d = torch.rand(1)
  s:push(a)
  s:push(b)
  s:push(c)
  s:push(d)

  tester:assertTensorEq(a, s:get(1), 1e-5)
  tester:assertTensorEq(b, s:get(2), 1e-5)
  tester:assertTensorEq(c, s:get(3), 1e-5)
  tester:assertTensorEq(d, s:get(4), 1e-5)

  local got = s:batch({1, 2}, -1)
  tester:asserteq(got:size(1), 2)
  tester:assertTensorEq(got[1][{{6, 10}}], a, 1e-5)
  tester:assertTensorEq(got[2], b, 1e-5)

  got = s:batch({3, 4}, -1)
  tester:asserteq(got:size(1), 2)
  tester:assertTensorEq(got[1], c, 1e-5)
  tester:asserteq(got[{2, 7}], d[1])

  got = s:batch({4, 1, 3}, -1)
  tester:asserteq(got:size(1), 3)
  tester:asserteq(got[{1, 7}], d[1])
  tester:assertTensorEq(got[2][{{3, 7}}], a, 1e-5)
  tester:assertTensorEq(got[3], c, 1e-5)
end

function TestVariableTensor.testPush()
  local s = VariableTensor()
  for i = 1, 100 do
    local n = torch.random(100)
    local t = torch.rand(n)
    s:push(t)
    local start, finish = s.indices[s:size()][1], s.indices[s:size()][2]
    local got = s.store[{{start, finish}}]
    tester:assertTensorEq(t, got, 1e-5)
    tester:assertTensorEq(t, s:get(i), 1e-5)
  end
  tester:asserteq(s:size(), 100)
end

function TestVariableTensor.testShuffle()
  local s = VariableTensor()
  local a, b, c, d = torch.rand(2), torch.rand(3), torch.rand(4), torch.rand(5)
  s:push(a)
  s:push(b)
  s:push(c)
  s:push(d)

  s:shuffle()
end


tester:add(TestVariableTensor)
tester:run()
