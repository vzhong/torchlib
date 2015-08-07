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

function Graph:resetState()
  -- initialize all nodes to undiscovered, source to visited
  local nodes = self:nodeSet():toTable()
  for i = 1, #nodes do
    local node = nodes[i]
    node.state = Graph.state.UNDISCOVERED
    node.timestamp = math.huge
    node.parent = nil
  end
end

function Graph:breadthFirstSearch(source)
  self:resetState()
  source.state = Graph.state.VISITED
  source.timestamp = 0
  
  local q = Queue.new()
  q:enqueue(source)

  while not q:isEmpty() do
    local node = q:dequeue()
    local conns = self:connectionsOf(node)
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

function Graph:depthFirstSearch(finishCallback, discoverCallback, nodes)
  self:resetState()
  local timestamp = 0
  local nodes = nodes or self:nodeSet():toTable()

  local function DFSVisit(graph, node)
    timestamp = timestamp + 1
    node.timestamp = timestamp
    node.state = Graph.state.VISITED
    local conns = self:connectionsOf(node)
    for i = 1, #conns do
      local conn = conns[i]
      if conn.state == Graph.state.UNDISCOVERED then
        conn.parent = node
        DFSVisit(graph, conn)
      end
    end
    node.state = Graph.state.FINISHED
    timestamp = timestamp + 1
    node.finishTime = timestamp
    if finishCallback ~= nil then
      finishCallback(node)
    end
  end

  local roots = {}
  for i = 1, #nodes do
    local node = nodes[i]
    if node.state == Graph.state.UNDISCOVERED then
      DFSVisit(graph, node)
      if discoverCallback ~= nil then
        discoverCallback(node)
      end
    end
  end
end


local DirectedGraph = torch.class('DirectedGraph', 'Graph')

function DirectedGraph:connect(nodeA, nodeB)
  self:assertValidNode(nodeA)
  self:assertValidNode(nodeB)
  self._nodeMap:get(nodeA):add(nodeB)
end

function DirectedGraph:topologicalSort()
  ordered = {}
  local function callback(node)
    table.insert(ordered, 1, node)
  end
  self:depthFirstSearch(callback)
  return ordered
end

function DirectedGraph:hasCycle()
  self:resetState()
  local nodes = self:nodeSet():toTable()

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
      if DFSVisit(graph, node) then
        return true
      end
    end
  end
  return false
end

function DirectedGraph:transpose()
  local g = DirectedGraph.new()
  g._nodeMap = self._nodeMap:copy()
  local nodes = g:nodeSet():toTable()
  -- clear out the connections first
  for i = 1, #nodes do
    local node = nodes[i]
    g._nodeMap:add(node, Set.new())
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

function DirectedGraph:stronglyConnectedComponents()
  local firstToLastFinish = self:topologicalSort()
  local transpose = self:transpose()
  local roots = {}
  function discoverCallback(node)
    table.insert(roots, node)
  end
  self:depthFirstSearch(nil, discoverCallback, Util.reverseTable(firstToLastFinish))
  return roots
end


local UndirectedGraph = torch.class('UndirectedGraph', 'Graph')

function UndirectedGraph:connect(nodeA, nodeB)
  self:assertValidNode(nodeA)
  self:assertValidNode(nodeB)
  self._nodeMap:get(nodeA):add(nodeB)
  self._nodeMap:get(nodeB):add(nodeA)
end

