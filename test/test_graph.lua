local graph = require "graph"
local DirectedGraph = map.DirectedGraph


local TestMap = {}
local tester


function testMap(m)
  tester:asserteq(0, m:size())
  tester:asserteq(false, m:contains(10))
  m:add(10, 'hi')
  tester:asserteq(true, m:contains(10))
  tester:asserteq(false, m:contains('hi'))
  tester:asserteq(1, m:size())
  tester:asserteq('hi', m:get(10))
  m:add('key', 42)
  tester:asserteq(2, m:size())
  tester:asserteq(42, m:get('key'))
  tester:asserteq('hi', m:get(10))
  v = m:remove('key')
  tester:asserteq(42, v)
  tester:asserteq(1, m:size())
  tester:asserteq('hi', m:get(10))
end


function TestMap.testHashMap()
  local m = HashMap.new()
  testMap(m)
end


tester = torch.Tester()
tester:add(TestMap)
tester:run()
