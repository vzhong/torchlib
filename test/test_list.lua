local torchlib = require 'torchlib'

local TestList = {}
local tester

local TestGeneric = {}

function TestGeneric.testAdd(ListClass)
  local l = ListClass.new()
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

  tester:asserteq(true, l:contains(3))
  tester:asserteq(false, l:contains(0))
end

function TestGeneric.testSet(ListClass)
  local l = ListClass.new():addMany(10, 1, 3, 2, 4)
  l:set(2, 100)
  tester:asserteq(100, l:get(2))
end

function TestGeneric.testCopy(ListClass)
  local l = ListClass.new():addMany(10, 1, 3, 2, 4)
  tester:assert(ListClass.new():addMany(10, 1, 3, 2, 4):equals(l))
  tester:assert(not ListClass.new():addMany(10, 1, 3, 4):equals(l))
  tester:assert(not ListClass.new():addMany(10, 1, 3, 2, 4, 5):equals(l))
end

function TestGeneric.testSublist(ListClass)
  local l = ListClass.new():addMany(10, 1, 3, 2, 4)
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
  local a = ListClass.new():addMany(1, 2, 3)
  local b = ListClass.new():addMany(1, 2)
  tester:asserteq(false, a:equals(ListClass.new():addMany(1, 2)))
  tester:asserteq(false, a:equals(ListClass.new():addMany(1, 2, 4)))
  tester:asserteq(true, a:equals(ListClass.new():addMany(1, 2, 3)))
end

function TestGeneric.testRemove(ListClass)
  local l = ListClass.new():addMany(10, 1, 3, 2, 4)
  l:remove(3)
  tester:asserteq(true, l:equals(ListClass.new():addMany(10, 1, 2, 4)))
  l:remove(4)
  tester:asserteq(true, l:equals(ListClass.new():addMany(10, 1, 2)))
end

function TestGeneric.testSwap(ListClass)
  local l = ListClass.new():addMany('a', 'b', 'c', 'd', 'e')
  local expect = ListClass.new():addMany('a', 'e', 'c', 'd', 'b')
  tester:assert(l:swap(2, 5):equals(expect))
end

function TestGeneric.testSort(ListClass)
  local l = ListClass.new():addMany(5, 4, 2, 3, 1)
  local expect = ListClass.new():addMany(1, 2, 3, 4, 5)
  l:sort()
  tester:assert(l:equals(expect))
end

function TestGeneric.testToTable(ListClass)
  local l = ListClass.new():addMany(5, 4, 2, 3, 1)
  tester:assertTableEq({5, 4, 2, 3, 1}, l:toTable())
end

function testList(ListClass)
  for k, func in pairs(TestGeneric) do
    func(ListClass)
  end
end


function TestList.testArray()
  testList(ArrayList)
  local l = ArrayList.new():addMany(1, 2, 3)
  tester:asserteq('ArrayList[1, 2, 3]', tostring(l))
  l = ArrayList.new():addMany(1, 2, 3, 1, 2, 3, 1, 2, 3, 4, 5)
  tester:asserteq('ArrayList[1, 2, 3, 1, 2, ...]', tostring(l))
end

function TestList.testLinkedList()
  testList(LinkedList)
  local l = LinkedList.new():addMany(1, 2, 3)
  tester:asserteq('LinkedList[1, 2, 3]', tostring(l))
end


tester = torch.Tester()
tester:add(TestList)
tester:run()
