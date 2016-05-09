local tl = require('torchlib')
local List = tl.List
local LinkedList = tl.LinkedList
local ArrayList = tl.ArrayList

local TestList = torch.TestSuite()
local TestArrayList = torch.TestSuite()
local TestLinkedList = torch.TestSuite()
local tester = torch.Tester()

local TestGeneric = {}

function TestGeneric.testAdd(ListClass)
  local l = ListClass()
  tester:asserteq(0, l:size())

  l:add(10)
  tester:asserteq(1, l:size())
  tester:asserteq(10, l:get(1))

  l:add(7, 1)
  tester:asserteq(2, l:size())
  tester:asserteq(10, l:get(2))
  tester:asserteq(7, l:get(1))

  v = l:remove(1)
  tester:asserteq(7, v)
  tester:asserteq(1, l:size())

  l:addMany(1, 3, 2, 4)
  tester:asserteq(5, l:size())
  tester:asserteq(10, l:get(1))
  tester:asserteq(1, l:get(2))
  tester:asserteq(3, l:get(3))
  tester:asserteq(2, l:get(4))
  tester:asserteq(4, l:get(5))

  l:add(0, 3)
  tester:asserteq(6, l:size())
  tester:asserteq(10, l:get(1))
  tester:asserteq(1, l:get(2))
  tester:asserteq(0, l:get(3))
  tester:asserteq(3, l:get(4))
  tester:asserteq(2, l:get(5))
  tester:asserteq(4, l:get(6))

  tester:asserteq(true, l:contains(3))
  tester:asserteq(false, l:contains(11))
end

function TestGeneric.testSet(ListClass)
  local l = ListClass{10, 1, 3, 2, 4}
  l:set(2, 100)
  tester:asserteq(100, l:get(2))
end

function TestGeneric.testCopy(ListClass)
  local l = ListClass{10, 1, 3, 2, 4}
  tester:assert(ListClass{10, 1, 3, 2, 4}:equals(l))
  tester:assert(not ListClass{10, 1, 3, 4}:equals(l))
  tester:assert(not ListClass{10, 1, 3, 2, 4, 5}:equals(l))
end

function TestGeneric.testSublist(ListClass)
  local l = ListClass{10, 1, 3, 2, 4}
  local s = l:sublist(2, 4)
  tester:asserteq(3, s:size())
  tester:asserteq(1, s:get(1))
  tester:asserteq(3, s:get(2))
  tester:asserteq(2, s:get(3))

  s = l:sublist(4)
  tester:asserteq(2, s:size())
  tester:asserteq(2, s:get(1))
  tester:asserteq(4, s:get(2))
end

function TestGeneric.testEquals(ListClass)
  local a = ListClass{1, 2, 3}
  local b = ListClass{1, 2}
  tester:asserteq(false, a:equals(ListClass{1, 2}))
  tester:asserteq(false, a:equals(ListClass{1, 2, 4}))
  tester:asserteq(true, a:equals(ListClass{1, 2, 3}))
end

function TestGeneric.testRemove(ListClass)
  local l = ListClass{10, 1, 3, 2, 4}
  l:remove(3)
  tester:asserteq(true, l:equals(ListClass{10, 1, 2, 4}))
  l:remove(4)
  tester:asserteq(true, l:equals(ListClass{10, 1, 2}))
end

function TestGeneric.testCopy(ListClass)
  local l = ListClass{1, 2, 3}
  local l2 = l:copy()
  tester:assertTableEq({1, 2, 3}, l:totable())
  tester:assertTableEq({1, 2, 3}, l2:totable())
  tester:assert(l ~= l2)
end

function TestGeneric.testSwap(ListClass)
  local l = ListClass{'a', 'b', 'c', 'd', 'e'}
  local expect = ListClass{'a', 'e', 'c', 'd', 'b'}
  tester:assert(l:swap(2, 5):equals(expect))
end

function TestGeneric.testSort(ListClass)
  local l = ListClass{5, 4, 2, 3, 1}
  local expect = ListClass{1, 2, 3, 4, 5}
  l:sort()
  tester:assert(l:equals(expect))
end

function TestGeneric.testToTable(ListClass)
  local l = ListClass{5, 4, 2, 3, 1}
  tester:assertTableEq({5, 4, 2, 3, 1}, l:totable())
end

function TestList.testAbstractMethods()
  local funcs = {'__init', 'add', 'get', 'set', 'remove', 'equals', 'swap', 'totable'}
  for _, fname in ipairs(funcs) do
    tester:assertErrorPattern(List[fname], 'not implemented', fname..' should be a virtual method')
  end
end

function TestArrayList.testToStringArrayList()
  local l = ArrayList{1, 2, 3}
  tester:asserteq('tl.ArrayList[1, 2, 3]', tostring(l))
  l = ArrayList{1, 2, 3, 1, 2, 3, 1, 2, 3, 4, 5}
  tester:asserteq('tl.ArrayList[1, 2, 3, 1, 2, ...]', tostring(l))
end

function TestLinkedList.testToStringLinkedList()
  local l = LinkedList{1, 2, 3}
  tester:asserteq('tl.LinkedList[1, 2, 3]', tostring(l))
end

function TestList.testLinkedListNode()
  tester:asserteq('LinkedListNode(1)', tostring(tl.LinkedList.Node.new(1)))
end

for k, f in pairs(TestGeneric) do
  TestArrayList[k..'ArrayList'] = function() f(ArrayList) end
  TestLinkedList[k..'LinkedList'] = function() f(LinkedList) end
end

tester:add(TestList)
tester:add(TestArrayList)
tester:add(TestLinkedList)
tester:run()
