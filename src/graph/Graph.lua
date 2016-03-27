--[[Abstract graph.
A `Graph` consists of `GraphNode`s. Each `GraphNode` can be in three states:
  - `UNDISCOVERED`
  - `VISITED`
  - `FINISHED`
]]

local HashMap = tl.HashMap
local Set = tl.Set
local Queue = tl.Queue

local Graph, parent = torch.class('tl.Graph', 'tl.Object')
Graph.GraphNode = torch.class('tl.GraphNode', 'tl.Object')

Graph.state = {UNDISCOVERED = 1, VISITED = 2, FINISHED = 3}

--[[ Constructor for a node in the graph.

  Parameter:
  - `val`: the value for this node
]]
function Graph.GraphNode:__init(val)
  self.val = val
end

function Graph.GraphNode:__tostring__()
  return parent.__tostring__(self) .. '(' .. self.val .. ')'
end

--[[ Constructor for a graph. ]]
function Graph:__init()
  self._nodeMap = HashMap.new()
end

--[[ Returns the number of nodes in the graph. ]]
function Graph:size()
  return self._nodeMap:size()
end

--[[ Asserts that the node is in the graph. ]]
function Graph:assertValidNode(node)
  assert(self._nodeMap:contains(node), 'Error: node ' .. tostring(node.val) .. ' is not in graph')
end

--[[ Adds a node with value `val` to the graph. ]]
function Graph:addNode(val)
  local node = Graph.GraphNode.new(val)
  self._nodeMap:add(node, Set())
  return node
end

--[[ Returns a table of nodes that are children to `node`. ]]
function Graph:connectionsOf(node)
  self:assertValidNode(node)
  return self._nodeMap:get(node):totable()
end

--[[ Returns a `Set` of nodes in the graph. ]]
function Graph:nodeSet()
  return self._nodeMap:keySet()
end

--[[ Initializes all nodes to `UNDISCOVERED`. ]]
function Graph:resetState()
  local nodes = self:nodeSet():totable()
  for i = 1, #nodes do
    local node = nodes[i]
    node.state = Graph.state.UNDISCOVERED
    node.timestamp = math.huge
    node.parent = nil
  end
end

--[[ Performs BFS on this graph.

Parameters:
- `source`: the source node to start BFS
- `callbacks` (optional): a table with two optional callbacks

Available callbacks:
- `discover(node)`: called when a node is initially encountered
- `finish(node)`: called when a node has been fully explored (eg. its connected nodes have all been visited)
]]
function Graph:breadthFirstSearch(source, callbacks)
  callbacks = callbacks or {}
  callbacks.discover = callbacks.discover or function(node) end
  callbacks.finish = callbacks.finish or function(node) end
  self:resetState()
  source.state = Graph.state.VISITED
  callbacks.discover(source)
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
        callbacks.discover(conn)
        conn.timestamp = node.timestamp + 1
        conn.parent = node
        q:enqueue(conn)
      end
    end
    node.state = Graph.state.FINISHED
    callbacks.finish(node)
  end
end

--[[ Returns the shortest path from the `source` node to the `destination` node.

  Note: This function relies on the results from a BFS call. By default, a BFS is performed before
  retrieving the shortest path. Alternatively, if the caller has already performed BFS, then
  this BFS can be skipped by passing in `skipBFS = true`.
]]
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

--[[ Performs DFS on the graph.

Parameters:
- `nodes` (optional): the table of nodes on which to perform DFS. If not set, then all nodes in the graph are used.
- `callbacks` (optional): a table with two optional callbacks

Available callbacks:
- `discover(node)`: called when a node is initially encountered
- `finish(node)`: called when a node has been fully explored (eg. its connected nodes have all been visited)
]]
function Graph:depthFirstSearch(nodes, callbacks)
  callbacks = callbacks or {}
  callbacks.discover = callbacks.discover or function(node) end
  callbacks.finish = callbacks.finish or function(node) end
  self:resetState()
  local timestamp = 0
  local nodes = nodes or self:nodeSet():totable()

  local function DFSVisit(graph, node)
    timestamp = timestamp + 1
    node.timestamp = timestamp
    node.state = Graph.state.VISITED
    callbacks.discover(node)
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
    callbacks.finish(node)
  end

  local roots = {}
  for i = 1, #nodes do
    local node = nodes[i]
    if node.state == Graph.state.UNDISCOVERED then
      DFSVisit(graph, node)
    end
  end
end

return Graph
