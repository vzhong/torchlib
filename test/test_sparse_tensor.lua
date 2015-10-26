require 'torchlib'

local TestSet = {}
local tester

function TestSet.testPush()
  local s = SparseTensor.new()
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
tester:add(TestSet)
tester:run()

