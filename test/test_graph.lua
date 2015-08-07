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

function getUndirectedGraph()
  -- figure 22.3 from CLRS
  local g = UndirectedGraph.new()
  local r = g:addNode('r')
  local s = g:addNode('s')
  local t = g:addNode('t')
  local u = g:addNode('u')
  local v = g:addNode('v')
  local w = g:addNode('w')
  local x = g:addNode('x')
  local y = g:addNode('y')

  g:connect(v, r)
  g:connect(r, s)
  g:connect(s, w)
  g:connect(w, t)
  g:connect(w, x)
  g:connect(t, x)
  g:connect(t, u)
  g:connect(x, u)
  g:connect(x, y)
  g:connect(y, u)

  return g, r, s, t, u, v, w, x, y
end


function TestUndirectedGraph.testBFS()
  local g, r, s, t, u, v, w, x, y = getUndirectedGraph()
  g:breadthFirstSearch(s)

  tester:asserteq(0, s.timestamp)
  tester:asserteq(nil, s.parent)
  tester:asserteq(Graph.state.FINISHED, s.state)

  tester:asserteq(1, r.timestamp)
  tester:asserteq(s, r.parent)
  tester:asserteq(Graph.state.FINISHED, r.state)
  
  tester:asserteq(1, w.timestamp)
  tester:asserteq(s, w.parent)
  tester:asserteq(Graph.state.FINISHED, w.state)

  tester:asserteq(2, v.timestamp)
  tester:asserteq(r, v.parent)
  tester:asserteq(Graph.state.FINISHED, v.state)

  tester:asserteq(2, t.timestamp)
  tester:asserteq(w, t.parent)
  tester:asserteq(Graph.state.FINISHED, t.state)

  tester:asserteq(2, x.timestamp)
  tester:asserteq(w, x.parent)
  tester:asserteq(Graph.state.FINISHED, x.state)

  tester:asserteq(3, u.timestamp)
  tester:assert(u.parent == t or u.parent == x)
  tester:asserteq(Graph.state.FINISHED, u.state)

  tester:asserteq(3, y.timestamp)
  tester:asserteq(x, y.parent)
  tester:asserteq(Graph.state.FINISHED, y.state)
end

function TestUndirectedGraph.testShortestPath()
  local g, r, s, t, u, v, w, x, y = getUndirectedGraph()
  local got = g:shortestPath(s, y)
  tester:assertTableEq({s, w, x, y}, got)

  got = g:shortestPath(s, t, true)
  tester:assertTableEq({s, w, t}, got)

  got = g:shortestPath(v, y)
  tester:assertTableEq({v, r, s, w, x, y}, got)
end


tester = torch.Tester()
tester:add(TestDirectedGraph)
tester:add(TestUndirectedGraph)
tester:run()
