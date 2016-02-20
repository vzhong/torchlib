require 'torchlib'

local TestQueue = {}
local tester

function testQueue(q)
  tester:asserteq(0, q:size())

  q:enqueue(10)
  tester:asserteq(1, q:size())
  q:enqueue(20)
  tester:asserteq(2, q:size())

  tester:asserteq('Queue[10, 20]', tostring(q))

  v = q:dequeue()
  tester:asserteq(10, v)
  tester:asserteq(1, q:size())
  v = q:dequeue()
  tester:asserteq(20, v)
  tester:asserteq(0, q:size())
end


function TestQueue.testQueue()
  local q = Queue()
  testQueue(q)
end


tester = torch.Tester()
tester:add(TestQueue)
tester:run()
