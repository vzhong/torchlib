local GraphNode = torch.class('GraphNode')

function GraphNode:__init(id, val)
  self.id = id
  self.val = val
end


local Graph = torch.class('Graph')

function Graph:__init()
  self._edgeMap = HashMap.new()
  self._nodeMap = HashMap.new()
  self._num_nodes = 0
  self._num_edges = 0
end

function Graph:num_nodes()
  return self._num_nodes
end

function Graph:num_edges()
  return self._num_edges
end

function Graph:assertValidNode(node)
  assert(node.id ~= nil, 'node does not have valid id')
  assert(self._nodeMap:contains(node.id), 'node with id ' .. node.id .. ' is not in graph')
end

function Graph:addNode(val)
  self._num_nodes = self._num_nodes + 1
  id = self.num_nodes
  node = GraphNode.new(id, val)
  self._nodeMap.add(id, node)
end

function Graph:connectionOf(node)
  self:assertValidNode(node)
  return self._nodeMap.get(node.id)
end


local DirectedGraph = torch.class('DirectedGraph', 'Graph')

function DirectedGraph:connect(nodeA, nodeB)
  self:assertValidNode(nodeA)
  self:assertValidNode(nodeB)
  if not self._edgeMap:contains(nodeA.id) then
    self._edgeMap.add(nodeA.id, LinkedList.new())
  end
  self._edgeMap.get(nodeA.id).add(nodeB.id)
  self._num_edges = self._num_edges + 1
end


local UndirectedGraph = torch.class('UndirectedGraph', 'Graph')

function UndirectedGraph:connect(nodeA, nodeB)
  self:assertValidNode(nodeA)
  self:assertValidNode(nodeB)
  if not self._edgeMap:contains(nodeA.id) then
    self._edgeMap.add(nodeA.id, LinkedList.new())
  end
  if not self._edgeMap:contains(nodeB.id) then
    self._edgeMap.add(nodeB.id, LinkedList.new())
  end

  self._edgeMap.get(nodeA.id).add(nodeB.id)
  self._edgeMap.get(nodeB.id).add(nodeA.id)
  self._num_edges = self._num_edges + 1
end

