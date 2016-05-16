# Graph
Abstract graph implementation.

A `Graph` consists of `GraphNode`s. Each `GraphNode` can be in three states:
  - `UNDISCOVERED`
  - `VISITED`
  - `FINISHED`




## GraphNode:\_\_init(val)
[View source](http://github.com/vzhong/torchlib/blob/master/src//graph/Graph.lua#L26)

Constructor.

Arguments:

- `val ` (`any`): value for the new node.


## GraphNode:\_\_tostring\_\_()
[View source](http://github.com/vzhong/torchlib/blob/master/src//graph/Graph.lua#L31)



Returns:

- (`string`) string representation

## Graph:\_\_init()
[View source](http://github.com/vzhong/torchlib/blob/master/src//graph/Graph.lua#L36)

Constructor.


## Graph:size()
[View source](http://github.com/vzhong/torchlib/blob/master/src//graph/Graph.lua#L41)



Returns:

- (`int`) number of nodes in the graph.

## Graph:assertValidNode(node)
[View source](http://github.com/vzhong/torchlib/blob/master/src//graph/Graph.lua#L47)

Verifies that the node is in the graph

Arguments:

- `node ` (`Graph.Node`): the node to verify.


## Graph:addNode(val)
[View source](http://github.com/vzhong/torchlib/blob/master/src//graph/Graph.lua#L54)

Adds a node with given value to the graph.

Arguments:

- `val ` (`any`): value for the new node.

Returns:

- (`Graph.Node`) 

## Graph:connectionsOf(node)
[View source](http://github.com/vzhong/torchlib/blob/master/src//graph/Graph.lua#L63)

Returns neighbours of a given node.

Arguments:

- `node ` (`Graph.Node`): the node to find neighbours for.

Returns:

- (`table(Graph.Node)`) 

## Graph:nodeSet()
[View source](http://github.com/vzhong/torchlib/blob/master/src//graph/Graph.lua#L70)

Returns a set of nodes in the graph.

Returns:

- (`Set(Graph.Node)`) 

## Graph:resetState()
[View source](http://github.com/vzhong/torchlib/blob/master/src//graph/Graph.lua#L78)

Initializes all nodes to `Graph.state.UNDISCOVERED`.

Returns:

- (`Graph`) 

The graph will be returned

## Graph:breadthFirstSearch(source, callbacks)
[View source](http://github.com/vzhong/torchlib/blob/master/src//graph/Graph.lua#L99)

Performs breadth first search.

Arguments:

- `source ` (`Graph.Node`): the source node to start BFS.
- `callbacks ` (`table[string:function]`): a map with optional callbacks

Available callbacks:. Optional.

- `discover = function(Graph.Node)`: called when a node is initially encountered

- `finish = function(Graph.Node)`: called when a node has been fully explored (eg. its connected nodes have all been visited)

## Graph:shortestPath(source, destination, skipBFS)
[View source](http://github.com/vzhong/torchlib/blob/master/src//graph/Graph.lua#L138)

Returns the shortest path from source to destination

Arguments:

- `source ` (`Graph.Node`): starting node.
- `destination ` (`Graph.Node`): end node.
- `skipBFS ` (`boolean`): whether BFS has already been performned. Optional.

Note: This function relies on the results from a BFS call. By default, a BFS is performed before

retrieving the shortest path. Alternatively, if the caller has already performed BFS, then

this BFS can be skipped by passing in `skipBFS = true`.

## Graph:depthFirstSearch(nodes, callbacks)
[View source](http://github.com/vzhong/torchlib/blob/master/src//graph/Graph.lua#L167)

Performs depth first search.

Arguments:

- `nodes ` (`table[Graph.Node]`): the table of nodes on which to perform DFS. If not set, then all nodes in the graph are used.
- `callbacks ` (`table[string:function]`): a map with optional callbacks

Available callbacks:. Optional.

- `discover = function(Graph.Node)`: called when a node is initially encountered

- `finish = function(Graph.Node)`: called when a node has been fully explored (eg. its connected nodes have all been visited)

