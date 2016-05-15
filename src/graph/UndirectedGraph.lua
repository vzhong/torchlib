--- @module UndirectedGraph
-- Undirected graph implementation
-- This is a subclass of `Graph`.

local torch = require 'torch'
local UndirectedGraph = torch.class('tl.UndirectedGraph', 'tl.Graph')

--- Connects two nodes.
-- @arg {Graph.Node} nodeA - starting node
-- @arg {Graph.Node} nodeB - ending node
function UndirectedGraph:connect(nodeA, nodeB)
  self:assertValidNode(nodeA)
  self:assertValidNode(nodeB)
  self._nodeMap:get(nodeA):add(nodeB)
  self._nodeMap:get(nodeB):add(nodeA)
end

return UndirectedGraph
