require 'torchlib'

local TestMap = {}
local tester

function TestMap.testAdd()
  local m = HashMap.new()
  m:add(10, 'hi')
  local t = {}
  t[10] = 'hi'
  tester:assertTableEq(t, m._map)

  m:add(10, 'bye')
  t[10] = 'bye'
  tester:assertTableEq(t, m._map)

  m:add('hi', 1)
  t['hi'] = 1
  tester:assertTableEq(t, m._map)

  local tab = {'foo'}
  m:add(tab, 'bar')
  t[tab] = 'bar'
  tester:assertTableEq(t, m._map)
end

function TestMap.testContains()
  local m = HashMap.new()
  tester:assert(not m:contains('bar'))
  m:add('bar', 'foo')
  tester:assert(m:contains('bar'))
end

function TestMap.testGet()
  local m = HashMap.new()
  m:add(10, 'hi')
  m:add(20, 'bye')
  tester:asserteq('hi', m:get(10))
  tester:asserteq('bye', m:get(20))

  local s, e = pcall(m.get, m, 'bad')
  tester:assert(string.match(e, 'Error: key bad not found in HashMap'))
end

function TestMap.testRemove()
  local m = HashMap.new()
  m:add(10, 20)
  m:add(20, 30)
  m:remove(10)
  local t = {}
  t[20] = 30
  tester:assertTableEq(t, m._map)

  local s, e = pcall(m.remove, m, 'bad')
  tester:assert(string.match(e, 'Error: key bad not found in HashMap'))
end

function TestMap.testSize()
  local m = HashMap.new()
  tester:asserteq(0, m:size())
  m:add(10, 20) 
  tester:asserteq(1, m:size())
  m:add(20, 10)
  tester:asserteq(2, m:size())
  m:remove(20)
  tester:asserteq(1, m:size())
end

function TestMap.testToString()
  local m = HashMap.new()
  tester:asserteq('HashMap{}', tostring(m))
  m:add('foo', 'bar')
  tester:asserteq('HashMap{foo -> bar}', tostring(m))
  m:add(1, 2)
  tostring(m)
end


tester = torch.Tester()
tester:add(TestMap)
tester:run()
