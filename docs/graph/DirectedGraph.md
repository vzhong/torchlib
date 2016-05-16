# DirectedGraph
A directed graph implementation.
This is a subclass of `Graph`.




## DirectedGraph:connect(nodeA, nodeB)
[View source](http://github.com/vzhong/torchlib/blob/master/src//graph/DirectedGraph.lua#L12)

Connects two nodes.

Arguments:

- `nodeA ` (`Graph.Node`): starting node.
- `nodeB ` (`Graph.Node`): ending node.


## DirectedGraph:topologicalSort()
[View source](http://github.com/vzhong/torchlib/blob/master/src//graph/DirectedGraph.lua#L20)

Returns nodes in this graph in topologically sorted order

Returns:

- (`table`) 

## DirectedGraph:hasCycle()
[View source](http://github.com/vzhong/torchlib/blob/master/src//graph/DirectedGraph.lua#L31)

Returns whether the graph has a cycle

Returns:

- (`boolean`) 

## DirectedGraph:transpose()
[View source](http://github.com/vzhong/torchlib/blob/master/src//graph/DirectedGraph.lua#L63)

Returns a transpose of this graph (eg. with the edges reversed)

Returns:

- (`DirectedGraph`) 

## DirectedGraph:stronglyConnectedComponents()
[View source](http://github.com/vzhong/torchlib/blob/master/src//graph/DirectedGraph.lua#L87)

Returns strongly connected components.

Each strongly connected component is itself a table.

Returns:

- (`table[table]`) a table of strongly connected components.

