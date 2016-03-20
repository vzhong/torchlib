require 'torchlib'

local TestCounter = torch.TestSuite()
local tester = torch.Tester()

function TestCounter.test_get()
  local c = Counter()
  tester:asserteq(0, c:get('foo'))
  c.counts['foo'] = 10
  tester:asserteq(10, c:get('foo'))
end

function TestCounter.test_add()
  local c = Counter()
  tester:asserteq(1, c:add('foo'))
  tester:asserteq(1, c.counts.foo)
  tester:asserteq(3, c:add('foo', 2))
  tester:asserteq(3, c.counts.foo)
end

function TestCounter.test_reset()
  local c = Counter()
  c.counts.foo = 10
  c:reset()
  tester:asserteq(nil, c.counts.foo)
end

tester:add(TestCounter)
tester:run()
