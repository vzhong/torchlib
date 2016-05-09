local Set = require('torchlib').Set

local TestSet = torch.TestSuite()
local tester = torch.Tester()

-- seed the shuffling
torch.manualSeed(12)


function TestSet.testAdd()
  local s = Set()
  tester:assertTableEq({}, s._map)

  -- add number
  s:add(15)
  local t = {}
  t[15] = 15
  tester:assertTableEq(t, s._map)

  -- add duplicate number
  s:add(15)
  tester:assertTableEq(t, s._map)

  -- add table
  local tab = {'foo'}
  s:add(tab)
  t[torch.pointer(tab)] = tab
  tester:assertTableEq(t, s._map)

  -- add table with duplicate content
  local tab2 = {'foo'}
  s:add(tab2)
  t[torch.pointer(tab2)] = tab2
  tester:assertTableEq(t, s._map)

  -- add many
  s:addMany(1, 2, 3)
  t[1] = 1
  t[2] = 2
  t[3] = 3
  tester:assertTableEq(t, s._map)
end

function TestSet.testToTable()
  local s = Set()
  s:add(5)
  s:add('bar')
  local tab = {'foo', 'bar'}
  s:add(tab)

  local expect = {5, 'bar', tab}
  local got = {}

  -- make got a dictionary for easy lookup
  for i, v in ipairs(s:totable()) do
    got[v] = true
  end

  -- check length equal
  tester:asserteq(#expect, #s:totable())

  -- check each expected item is here
  for i, e in ipairs(expect) do
    tester:asserteq(true, got[e] ~= nil)
  end
end

function TestSet.testSize()
  local s = Set()
  tester:asserteq(0, s:size())

  s:add(15)
  tester:asserteq(1, s:size())

  s:add(16)
  tester:asserteq(2, s:size())
end

function TestSet.testContains()
  local s = Set()
  tester:asserteq(false, s:contains(nil))

  s:add(15)
  tester:asserteq(true, s:contains(15))

  s:add('foo')
  tester:asserteq(true, s:contains('foo'))

  local tab = {'foo'}
  s:add(tab)
  tester:asserteq(true, s:contains(tab))
end

function TestSet.testRemove()
  local s = Set()
  ret, err = pcall(Set.remove, s, 'bar')
  tester:assert(string.match(err, 'Error: value bar not found in Set') ~= nil)
  tester:asserteq(0, s:size())

  s:add('bar')
  tester:asserteq(1, s:size())
  s:remove('bar')
  tester:asserteq(0, s:size())
end

function TestSet.testEquals()
  local s = Set()
  local t = Set()
  tester:asserteq(true, s:equals(t))

  s:add(5)
  tester:asserteq(false, s:equals(t))
  t:add(5)
  tester:asserteq(true, s:equals(t))

  tester:asserteq(false, Set():addMany(1, 2):equals(Set():addMany(1)))
  tester:asserteq(false, Set():addMany(1):equals(Set():addMany(1, 2)))
  tester:asserteq(false, Set():addMany(1, 2):equals(Set():addMany(1, 3)))

  s:add(5)
  tester:asserteq(true, s:equals(t))

  s:add(10)
  tester:asserteq(false, s:equals(t))
end

function getToySets()
  local s = Set{5, 6}
  local t = Set{5, 7, 8}
  return s, t
end

function TestSet.testUnion()
  local s, t = getToySets()
  local expect = Set{5, 6, 7, 8}
  tester:assert(expect:equals(s:union(t)))
end

function TestSet.testIntersect()
  local s, t = getToySets()
  local expect = Set{5}
  tester:assert(expect:equals(s:intersect(t)))
end

function TestSet.testSubtract()
  local s, t = getToySets()
  local expect = Set{6}
  tester:assert(expect:equals(s:subtract(t)))
end

function TestSet.testToString()
  local s = Set():addMany(5)
  tester:asserteq('tl.Set(5)', tostring(s))
  s:add(6)
  tester:assert(tostring(s) == 'tl.Set(5, 6)' or tostring(s) == 'tl.Set(6, 5)')
end

function TestSet.testCopy()
  local s = Set{5, 6, 7}
  tester:assert(s:equals(Set{5, 6, 7}))
  tester:assert(not s:equals(Set{5, 7}))
  tester:assert(not s:equals(Set{5, 8, 6, 7}))
end

tester:add(TestSet)
tester:run()
