require 'torchlib'

local TestHeap = {}
local tester

function TestHeap.testPush()
  local h = Heap.new()
  h:push(10, 'bob')
  local p, v = table.unpack(h:get(1))
  tester:asserteq(10, p)
  tester:asserteq('bob', v)
  tester:asserteq(1, h:size())

  h:push(20, 'bill')
  p, v = table.unpack(h:get(1))
  tester:asserteq(20, p)
  tester:asserteq('bill', v)
  p, v = table.unpack(h:get(2))
  tester:asserteq(10, p)
  tester:asserteq('bob', v)
  tester:asserteq(2, h:size())

  h:push(15, 'ben')
  p, v = table.unpack(h:get(1))
  tester:asserteq(20, p)
  tester:asserteq('bill', v)
  p, v = table.unpack(h:get(2))
  tester:asserteq(15, p)
  tester:asserteq('ben', v)
  p, v = table.unpack(h:get(3))
  tester:asserteq(10, p)
  tester:asserteq('bob', v)
  tester:asserteq(3, h:size())
end

function TestHeap.testPop()
  local h = Heap.new()
  h:push(3, 'c')
  h:push(5, 'a')
  h:push(1, 'e')
  h:push(2, 'd')
  h:push(4, 'b')

  tester:asserteq('a', h:pop())
  tester:asserteq(4, h:size())
  tester:asserteq('b', h:pop())
  tester:asserteq(3, h:size())
  tester:asserteq('c', h:pop())
  tester:asserteq(2, h:size())
  tester:asserteq('d', h:pop())
  tester:asserteq(1, h:size())
  tester:asserteq('e', h:pop())
  tester:asserteq(0, h:size())
end

function TestHeap.testToString()
  local h = Heap.new()
  h:push(3, 'c')
  h:push(5, 'a')
  h:push(2, 'd')
  h:push(4, 'b')

  tester:asserteq('Heap[a(5), b(4), d(2), c(3)]', tostring(h))

  h:push(4, 'v')
  tester:asserteq('Heap[a(5), v(4), b(4), d(2), c(3), ...]', tostring(h))
end

function TestHeap.testSort()
  local h = Heap.new()
  h:push(3, 'c')
  h:push(5, 'a')
  h:push(2, 'd')
  h:push(4, 'b')
  h:sort()
  tester:asserteq('Heap[d(2), c(3), b(4), a(5)]', tostring(h))
end

tester = torch.Tester()
tester:add(TestHeap)
tester:run()
