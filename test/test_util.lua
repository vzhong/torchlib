local tl = require('torchlib')

local TestGlobal = torch.TestSuite()
local TestTable = torch.TestSuite()
local TestString = torch.TestSuite()
local tester = torch.Tester()

math.randomseed(123)

function TestGlobal.test_range()
  tester:assertTableEq({2, 3, 4}, tl.range(2, 4, 1))
  tester:assertTableEq({3, 2}, tl.range(3, 2, -1))
  tester:assertTableEq({1, 2, 3}, tl.range(3))
end

function TestGlobal.test_equals()
  tester:asserteq(true, tl.equals('a', 'a'))
  tester:asserteq(false, tl.equals({}, 'a'))
  tester:asserteq(false, tl.equals({}, {}))
  tester:asserteq(true, tl.equals(tl.Set():add(5), tl.Set():add(5)))
end

function TestGlobal.test_copy()
  local s = {}
  local a = {a=1, b=s}
  local b = tl.copy(a)
  tester:asserteq(false, a == b)
  tester:asserteq(true, a.a == b.a)
  tester:asserteq(true, a.b == b.b)
  tester:asserteq(true, a.b == s)
end

function TestGlobal.test_deep_copy()
  local s = {}
  local a = {a=1, b=s}
  local b = tl.deepcopy(a)
  tester:asserteq(false, a == b)
  tester:asserteq(true, a.a == b.a)
  tester:asserteq(false, a.b == b.b)
  tester:asserteq(true, a.b == s)
end

function TestString.test_startswith()
  tester:asserteq(true, string.startswith('bob', 'bo'))
  tester:asserteq(false, string.startswith('bob', 'o'))
end

function TestString.test_endswith()
  tester:asserteq(true, string.endswith('bob', 'ob'))
  tester:asserteq(false, string.endswith('bob', 'o'))
end

function TestTable.test_print()
  local a = {a=1, b={c=3}}
  local expect = [[a: 1
b: 
  c: 3
]]
  local got = table.tostring(a)
  tester:asserteq(expect, got)
end

function TestTable.test_shuffle()
  local t = {1, 2, 3, 4}
  table.shuffle(t)
  tester:assertTableEq({4, 2, 3, 1}, t)
end

function TestTable.test_table_equals()
  tester:asserteq(true, table.equals({1, 2}, {1, 2}))
  tester:asserteq(false, table.equals({1}, {1, 2}))
  tester:asserteq(false, table.equals({1, 2}, {1}))
end

function TestTable.test_values_equal()
  tester:asserteq(true, table.valuesEqual({1, 2}, {1, 2}))
  tester:asserteq(false, table.valuesEqual({1}, {1, 2}))
  tester:asserteq(false, table.valuesEqual({1, 2}, {1}))
  tester:asserteq(true, table.valuesEqual({a=1, b=2}, {a=1, b=2}))
  tester:asserteq(false, table.valuesEqual({a=1}, {a=1, b=2}))
  tester:asserteq(false, table.valuesEqual({a=1, b=2}, {a=1}))
end

function TestTable.test_contains()
  tester:asserteq(true, table.contains({'a', 'b'}, 'b'))
  tester:asserteq(false, table.contains({'a', 'b'}, 'c'))
end

function TestTable.test_flatten()
  tester:assertTableEq({a=1, ['b__c']=3}, table.flatten{a=1, b={c=3}})
  tester:assertTableEq({a=1, b=2}, table.flatten{a=1, b=2})
end

function TestTable.test_map()
  tester:assertTableEq({2, 3, 4}, table.map({1, 2, 3}, function(x) return x+1 end))
end

function TestTable.test_select()
  tester:assertTableEq({'b', 'c'}, table.select({'a', 'b', 'c', 'd'}, {2, 3}, true))
  tester:assertTableEq({a=1}, table.select({a=1, b=2}, {'a'}))
  tester:assertTableEq({2}, table.select({a=1, b=2}, {'b'}, true))
end

function TestTable.test_extend()
  tester:assertTableEq({2, 3, 4, 5, 6}, table.extend({2, 3, 4}, {5, 6}))
end

function TestTable.test_combinations()
  local got = table.combinations{{1, 2}, {'a', 'b', 'c'}}
  local expect = {{1, 'a'}, {2, 'a'}, {1, 'b'}, {2, 'b'}, {1, 'c'}, {2, 'c'}}
  tester:assertTableEq(expect, got)
end

tester:add(TestGlobal)
tester:add(TestTable)
tester:add(TestString)
tester:run()
