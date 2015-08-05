local Graph = torch.class('Graph')
Graph.GraphNode = torch.class('GraphNode')

function Graph.GraphNode:__init(val)
  self.val = val
end

function Graph.GraphNode:toString()
  return 'GraphNode(' .. self.val .. ')'
end

torch.getmetatable('GraphNode').__tostring__ = Graph.GraphNode.toString

function Graph:__init()
  self._nodeMap = HashMap.new()
end

function Graph:size()
  return self._nodeMap:size()
end

function Graph:assertValidNode(node)
  assert(self._nodeMap:contains(node), 'Error: node ' .. tostring(node.val) .. ' is not in graph')
end

function Graph:addNode(val)
  local node = Graph.GraphNode.new(val)
  self._nodeMap:add(node, Set.new())
  return node
end

function Graph:connectionsOf(node)
  self:assertValidNode(node)
  return self._nodeMap:get(node):asTable()
end

local DirectedGraph = torch.class('DirectedGraph', 'Graph')

function DirectedGraph:connect(nodeA, nodeB)
  self:assertValidNode(nodeA)
  self:assertValidNode(nodeB)
  self._nodeMap:get(nodeA):add(nodeB)
end


local UndirectedGraph = torch.class('UndirectedGraph', 'Graph')

function UndirectedGraph:connect(nodeA, nodeB)
  self:assertValidNode(nodeA)
  self:assertValidNode(nodeB)
  self._nodeMap:get(nodeA):add(nodeB)
  self._nodeMap:get(nodeB):add(nodeA)
end

