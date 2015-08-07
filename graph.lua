local Graph = torch.class('Graph')
Graph.GraphNode = torch.class('GraphNode')

Graph.state = {UNDISCOVERED = 1, VISITED = 2, FINISHED = 3}

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
  -- returns a table list of nodes that are children to node
  self:assertValidNode(node)
  return self._nodeMap:get(node):toTable()
end

function Graph:nodeSet()
  return self._nodeMap:keySet()
end

function Graph:breadthFirstSearch(source)
  -- initialize all nodes to undiscovered, source to visited
  local nodes = self:nodeSet():toTable()
  for i = 1, #nodes do
    local node = nodes[i]
    node.state = Graph.state.UNDISCOVERED
    node.timestamp = math.huge
    node.parent = nil
  end
  source.state = Graph.state.VISITED
  source.timestamp = 0
  
  local q = Queue.new()
  q:enqueue(source)

  while not q:isEmpty() do
    local node = q:dequeue()
    conns = self:connectionsOf(node)
    for i = 1, #conns do
      local conn = conns[i]
      if conn.state == Graph.state.UNDISCOVERED then
        conn.state = Graph.state.VISITED
        conn.timestamp = node.timestamp + 1
        conn.parent = node
        q:enqueue(conn)
      end
    end
    node.state = Graph.state.FINISHED
  end
end

function Graph:shortestPath(source, destination, skipBFS)
  if skipBFS ~= true then
    self:breadthFirstSearch(source)
  end
  local function recur(graph, source, destination, path)
    if source == destination then
      table.insert(path, destination)
    elseif destination.parent == nil then
      error('Error: no path from ' .. tostring(source) .. ' to ' .. tostring(destination))
    else
      recur(graph, source, destination.parent, path)
      table.insert(path, destination)
    end
  end
  local path = {}
  recur(self, source, destination, path)
  return path
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

