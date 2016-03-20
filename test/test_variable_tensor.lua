require 'torchlib'

local TestVariableTensor = torch.TestSuite()
local tester = torch.Tester()

function TestVariableTensor.testSize()
  local s = VariableTensor.new()
  tester:asserteq(s:size(), 0)
end

function TestVariableTensor:testBatch()
  local s = VariableTensor.new()
  local a = torch.rand(5)
  local b = torch.rand(10)
  s:push(a)
  s:push(b)

  local got, mask = s:batch(torch.range(1, 2))
  tester:asserteq(got:size(1), 2)
  tester:asserteq(mask:size(1), 2)
  tester:assertTensorEq(mask:sum(2), torch.Tensor{5, 10}, 1e-5)
  
  tester:assertTensorEq(got[1][{{1, 5}}], a, 1e-5)
  tester:assertTensorEq(got[2], b, 1e-5)
  tester:asserteq(s.max_len, 10)

  local c = torch.rand(7)
  local d = torch.rand(1)
  s:push(c)
  s:push(d)
  local holder = torch.Tensor(5, s.max_len)
  got, mask = s:batch(torch.range(2, 4))
  tester:asserteq(got:size(1), 3)
  tester:asserteq(mask:size(1), 3)
  tester:assertTensorEq(mask:sum(2), torch.Tensor{10, 7, 1}, 1e-5)

  tester:assertTensorEq(got[1], b, 1e-5)
  tester:assertTensorEq(got[2][{{1, 7}}], c, 1e-5)
  tester:assertTensorEq(got[3][{{1, 1}}], d, 1e-5)
end

function TestVariableTensor.testPush()
  local s = VariableTensor.new()
  for i = 1, 100 do
    local n = torch.random(100)
    local t = torch.rand(n)
    s:push(t)
    local start, finish = s.indices[s:size()][1], s.indices[s:size()][2]
    local got = s.store[{{start, finish}}]
    tester:asserteq(t:eq(got):sum(), n)
    tester:asserteq(s:get(i):eq(got):sum(), n)
  end
  tester:asserteq(s:size(), 100)
end

tester:add(TestVariableTensor)
tester:run()

