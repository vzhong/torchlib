--[[ Undirected graph implementation. ]]
local UndirectedGraph = torch.class('tl.UndirectedGraph', 'tl.Graph')

--[[ Connects `nodeA` to `nodeB`]]
function UndirectedGraph:connect(nodeA, nodeB)
  self:assertValidNode(nodeA)
  self:assertValidNode(nodeB)
  self._nodeMap:get(nodeA):add(nodeB)
  self._nodeMap:get(nodeB):add(nodeA)
end

return UndirectedGraph
