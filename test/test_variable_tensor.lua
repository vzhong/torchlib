require 'torchlib'

local TestVariableTensor = {}
local tester

function TestVariableTensor.testSize()
  local s = VariableTensor.new()
  tester:asserteq(s:size(), 0)
end

function TestVariableTensor.testLengthMap()
  local s = VariableTensor.new()
  local a = torch.Tensor{-1, -2, -3}
  local b = torch.Tensor{1, 2, 3, 4, 5}
  local c = torch.Tensor{1, 2, 3}
  s:push(a)
  s:push(b)
  s:push(c)
  local lengths, length_map = s:length_map()
  tester:asserteq(length_map[3]:size(1), 2)
  tester:asserteq(length_map[5]:size(1), 1)
  tester:assert(length_map[3]:eq(torch.LongTensor{1, 3}))
  tester:assert(length_map[5]:eq(torch.LongTensor{2}))
  tester:assert(lengths:eq(torch.IntTensor{3, 5}))
end

function TestVariableTensor:testBatch()
  local s = VariableTensor.new()
  local function push(n, len)
    for i = 1, n do
      local t = torch.rand(len)
      s:push(t)
    end
  end
  push(10, 5)
  push(9, 8)
  push(100, 2)

  local batch_size = 10

  while true do
    local len, idx = s:get_batch_indices(batch_size)
    if not len then break end
    local batch = s:make_batch(len, idx)
    tester:assert(batch:size(1) <= 10)
    tester:asserteq(batch:size(2), len)
  end
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

tester = torch.Tester()
tester:add(TestVariableTensor)
tester:run()

