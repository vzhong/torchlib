local Stack = require('torchlib').Stack

local TestStack = torch.TestSuite()
local tester = torch.Tester()

function TestStack.testStack()
  local s = Stack.new()
  tester:asserteq(0, s:size())

  s:push(10)
  tester:asserteq(1, s:size())
  s:push(20)
  tester:asserteq(2, s:size())

  tester:asserteq('tl.Stack[10, 20]', tostring(s))

  v = s:pop()
  tester:asserteq(20, v)
  tester:asserteq(1, s:size())
  v = s:pop()
  tester:asserteq(10, v)
  tester:asserteq(0, s:size())
end


tester:add(TestStack)
tester:run()
