require 'torchlib'

local TestDirectedGraph = {}
local TestUndirectedGraph = {}
local tester


function TestDirectedGraph.testAddNode()
  local g = DirectedGraph.new()
  local na = g:addNode('a')
  local nb = g:addNode('b')
  local nc = g:addNode('c')
  tester:asserteq(3, g:size())

  g:connect(na, nb)
  g:connect(nc, na)
  tester:assertTableEq({nb}, g:connectionsOf(na))
  tester:assertTableEq({na}, g:connectionsOf(nc))
end


function TestUndirectedGraph.testAddNode()
  local g = UndirectedGraph.new()
  local na = g:addNode('a')
  local nb = g:addNode('b')
  local nc = g:addNode('c')
  tester:asserteq(3, g:size())

  g:connect(na, nb)
  g:connect(nc, na)
  tester:assert(Util.tableValuesEqual({nb, nc}, g:connectionsOf(na)))
  tester:assertTableEq({na}, g:connectionsOf(nc))
end


tester = torch.Tester()
tester:add(TestDirectedGraph)
tester:add(TestUndirectedGraph)
tester:run()
