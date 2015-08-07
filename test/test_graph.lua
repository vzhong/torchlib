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

function getDirectedGraph()
  -- from CLRS fig 22.4
  local g = DirectedGraph.new()
  local u = g:addNode('u')
  local v = g:addNode('v')
  local w = g:addNode('w')
  local x = g:addNode('x')
  local y = g:addNode('y')
  local z = g:addNode('z')
  g:connect(u, v)
  g:connect(u, x)
  g:connect(x, v)
  g:connect(v, y)
  g:connect(y, x)
  g:connect(w, y)
  g:connect(w, z)
  g:connect(z, z)
  return g
end

function getDirectedAcyclicGraph()
  -- from CLRS fig 22.7
  local g = DirectedGraph.new()
  local undershorts = g:addNode('undershorts')
  local pants = g:addNode('pants')
  local belt = g:addNode('belt')
  local shirt = g:addNode('shirt')
  local tie = g:addNode('tie')
  local jacket = g:addNode('jacket')
  local socks = g:addNode('socks')
  local shoes = g:addNode('shoes')
  local watch = g:addNode('watch')
  g:connect(undershorts, pants)
  g:connect(undershorts, shoes)
  g:connect(socks, shoes)
  g:connect(pants, shoes)
  g:connect(pants, belt)
  g:connect(shirt, belt)
  g:connect(shirt, tie)
  g:connect(tie, jacket)
  g:connect(belt, jacket)
  return g, undershorts, pands, belt, shirt, tie, jacket, socks, shoes, watch
end

function TestDirectedGraph.testDFS()
  local g = getDirectedGraph()
  g:depthFirstSearch()
  -- test correctness
end

function TestDirectedGraph.testTopologicalSort()
  local g, undershorts, pands, belt, shirt, tie, jacket, socks, shoes, watch = getDirectedAcyclicGraph()
  local sorted = g:topologicalSort()
  -- test correctness automatically
  -- Util.printTable(sorted)
end

function TestDirectedGraph.testHasCycle()
  local g = getDirectedGraph()
  tester:assert(g:hasCycle())
  g = getDirectedAcyclicGraph()
  tester:assert(not g:hasCycle())
end



tester = torch.Tester()
tester:add(TestDirectedGraph)
tester:add(TestUndirectedGraph)
tester:run()
