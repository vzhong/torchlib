--- @module DirectedGraph
-- A directed graph implementation.
-- This is a subclass of `Graph`.
local torch = require 'torch'
local DirectedGraph = torch.class('tl.DirectedGraph', 'tl.Graph')
local Set = tl.Set
local Graph = tl.Graph

--- Connects two nodes.
-- @arg {Graph.Node} nodeA - starting node
-- @arg {Graph.Node} nodeB - ending node
function DirectedGraph:connect(nodeA, nodeB)
  self:assertValidNode(nodeA)
  self:assertValidNode(nodeB)
  self._nodeMap:get(nodeA):add(nodeB)
end

--- Returns nodes in this graph in topologically sorted order
-- @returns {table}
function DirectedGraph:topologicalSort()
  local ordered = {}
  local function callback(node)
    table.insert(ordered, 1, node)
  end
  self:depthFirstSearch(self:nodeSet():totable(), {finish=callback})
  return ordered
end

--- Returns whether the graph has a cycle
-- @returns {boolean}
function DirectedGraph:hasCycle()
  self:resetState()
  local nodes = self:nodeSet():totable()

  local function DFSVisit(graph, node)
    node.state = Graph.state.VISITED
    local conns = self:connectionsOf(node)
    for i = 1, #conns do
      local conn = conns[i]
      if conn.state == Graph.state.VISITED then
        return true -- looped back to ancestor
      elseif conn.state == Graph.state.UNDISCOVERED then
        DFSVisit(graph, conn)
      end
    end
    node.state = Graph.state.FINISHED
    return false
  end

  for i = 1, #nodes do
    local node = nodes[i]
    if node.state == Graph.state.UNDISCOVERED then
      if DFSVisit(self, node) then
        return true
      end
    end
  end
  return false
end

--- Returns a transpose of this graph (eg. with the edges reversed)
-- @returns {DirectedGraph}
function DirectedGraph:transpose()
  local g = DirectedGraph.new()
  g._nodeMap = self._nodeMap:copy()
  local nodes = g:nodeSet():totable()
  -- clear out the connections first
  for i = 1, #nodes do
    local node = nodes[i]
    g._nodeMap:add(node, Set())
  end
  -- add in transpose connections
  for i = 1, #nodes do
    local node = nodes[i]
    local conns = self:connectionsOf(node)
    for j = 1, #conns do
      local conn = conns[j]
      g:connect(conn, node)
    end
  end
  return g
end

--- Returns strongly connected components.
-- Each strongly connected component is itself a table.
-- @returns {table[table]} a table of strongly connected components.
function DirectedGraph:stronglyConnectedComponents()
  local firstToLastFinish = self:topologicalSort()
  local roots = {}
  local discoverCallback = function(node)
    table.insert(roots, node)
  end
  self:depthFirstSearch(table.reverse(firstToLastFinish), {discover=discoverCallback})
  return roots
end

return DirectedGraph
