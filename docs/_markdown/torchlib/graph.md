<a name="torchlib.Graph.dok"></a>


## torchlib.Graph ##

Abstract graph.
A `Graph` consists of `GraphNode`s. Each `GraphNode` can be in three states:
  - `UNDISCOVERED`
  - `VISITED`
  - `FINISHED`

<a name="torchlib.DirectedGraph.dok"></a>


## torchlib.DirectedGraph ##

 A directed graph implementation. 
<a name="torchlib.UndirectedGraph.dok"></a>


## torchlib.UndirectedGraph ##

 Undirected graph implementation. 

<a class="entityLink" href="https://github.com/vzhong/torchlib/blob/975ba472d6e4fdaa1f6c82e04d3ff16b691aaa02/graph.lua#L17">[src]</a>
<a name="torchlib.Graph.GraphNode"></a>


### torchlib.Graph.GraphNode(val) ###

 Constructor for a node in the graph.

  Parameter:
  - `val`: the value for this node


<a class="entityLink" href="https://github.com/vzhong/torchlib/blob/975ba472d6e4fdaa1f6c82e04d3ff16b691aaa02/graph.lua#L28">[src]</a>
<a name="torchlib.Graph"></a>


### torchlib.Graph() ###

 Constructor for a graph. 

<a class="entityLink" href="https://github.com/vzhong/torchlib/blob/975ba472d6e4fdaa1f6c82e04d3ff16b691aaa02/graph.lua#L33">[src]</a>
<a name="torchlib.Graph:size"></a>


### torchlib.Graph:size() ###

 Returns the number of nodes in the graph. 

<a class="entityLink" href="https://github.com/vzhong/torchlib/blob/975ba472d6e4fdaa1f6c82e04d3ff16b691aaa02/graph.lua#L38">[src]</a>
<a name="torchlib.Graph:assertValidNode"></a>


### torchlib.Graph:assertValidNode(node) ###

 Asserts that the node is in the graph. 

<a class="entityLink" href="https://github.com/vzhong/torchlib/blob/975ba472d6e4fdaa1f6c82e04d3ff16b691aaa02/graph.lua#L43">[src]</a>
<a name="torchlib.Graph:addNode"></a>


### torchlib.Graph:addNode(val) ###

 Adds a node with value `val` to the graph. 

<a class="entityLink" href="https://github.com/vzhong/torchlib/blob/975ba472d6e4fdaa1f6c82e04d3ff16b691aaa02/graph.lua#L50">[src]</a>
<a name="torchlib.Graph:connectionsOf"></a>


### torchlib.Graph:connectionsOf(node) ###

 Returns a table of nodes that are children to `node`. 

<a class="entityLink" href="https://github.com/vzhong/torchlib/blob/975ba472d6e4fdaa1f6c82e04d3ff16b691aaa02/graph.lua#L56">[src]</a>
<a name="torchlib.Graph:nodeSet"></a>


### torchlib.Graph:nodeSet() ###

 Returns a `Set` of nodes in the graph. 

<a class="entityLink" href="https://github.com/vzhong/torchlib/blob/975ba472d6e4fdaa1f6c82e04d3ff16b691aaa02/graph.lua#L61">[src]</a>
<a name="torchlib.Graph:resetState"></a>


### torchlib.Graph:resetState() ###

 Initializes all nodes to `UNDISCOVERED`. 

<a class="entityLink" href="https://github.com/vzhong/torchlib/blob/975ba472d6e4fdaa1f6c82e04d3ff16b691aaa02/graph.lua#L81">[src]</a>
<a name="torchlib.Graph:breadthFirstSearch"></a>


### torchlib.Graph:breadthFirstSearch(source, callbacks) ###

 Performs BFS on this graph.

Parameters:
- `source`: the source node to start BFS
- `callbacks` (optional): a table with two optional callbacks

Available callbacks:
- `discover(node)`: called when a node is initially encountered
- `finish(node)`: called when a node has been fully explored (eg. its connected nodes have all been visited)


<a class="entityLink" href="https://github.com/vzhong/torchlib/blob/975ba472d6e4fdaa1f6c82e04d3ff16b691aaa02/graph.lua#L117">[src]</a>
<a name="torchlib.Graph:shortestPath"></a>


### torchlib.Graph:shortestPath(source, destination, skipBFS) ###

 Returns the shortest path from the `source` node to the `destination` node.

  Note: This function relies on the results from a BFS call. By default, a BFS is performed before
  retrieving the shortest path. Alternatively, if the caller has already performed BFS, then
  this BFS can be skipped by passing in `skipBFS = true`.


<a class="entityLink" href="https://github.com/vzhong/torchlib/blob/975ba472d6e4fdaa1f6c82e04d3ff16b691aaa02/graph.lua#L146">[src]</a>
<a name="torchlib.Graph:depthFirstSearch"></a>


### torchlib.Graph:depthFirstSearch(nodes, callbacks) ###

 Performs DFS on the graph.

Parameters:
- `nodes` (optional): the table of nodes on which to perform DFS. If not set, then all nodes in the graph are used.
- `callbacks` (optional): a table with two optional callbacks

Available callbacks:
- `discover(node)`: called when a node is initially encountered
- `finish(node)`: called when a node has been fully explored (eg. its connected nodes have all been visited)


<a class="entityLink" href="https://github.com/vzhong/torchlib/blob/975ba472d6e4fdaa1f6c82e04d3ff16b691aaa02/graph.lua#L187">[src]</a>
<a name="torchlib.DirectedGraph:connect"></a>


### torchlib.DirectedGraph:connect(nodeA, nodeB) ###

 Connects `nodeA` to `nodeB`. 

<a class="entityLink" href="https://github.com/vzhong/torchlib/blob/975ba472d6e4fdaa1f6c82e04d3ff16b691aaa02/graph.lua#L194">[src]</a>
<a name="torchlib.DirectedGraph:topologicalSort"></a>


### torchlib.DirectedGraph:topologicalSort() ###

 Returns a table of the nodes in this graph in topologically sorted order. 

<a class="entityLink" href="https://github.com/vzhong/torchlib/blob/975ba472d6e4fdaa1f6c82e04d3ff16b691aaa02/graph.lua#L204">[src]</a>
<a name="torchlib.DirectedGraph:hasCycle"></a>


### torchlib.DirectedGraph:hasCycle() ###

 Returns whether the graph has a cycle. 

<a class="entityLink" href="https://github.com/vzhong/torchlib/blob/975ba472d6e4fdaa1f6c82e04d3ff16b691aaa02/graph.lua#L235">[src]</a>
<a name="torchlib.DirectedGraph:transpose"></a>


### torchlib.DirectedGraph:transpose() ###

 Returns a transpose of this graph (eg. with the edges reversed) 

<a class="entityLink" href="https://github.com/vzhong/torchlib/blob/975ba472d6e4fdaa1f6c82e04d3ff16b691aaa02/graph.lua#L257">[src]</a>
<a name="torchlib.DirectedGraph:stronglyConnectedComponents"></a>


### torchlib.DirectedGraph:stronglyConnectedComponents() ###

 Returns a table of strongly connected components. Each strongly connected component is itself a table. 

<a class="entityLink" href="https://github.com/vzhong/torchlib/blob/975ba472d6e4fdaa1f6c82e04d3ff16b691aaa02/graph.lua#L273">[src]</a>
<a name="torchlib.UndirectedGraph:connect"></a>


### torchlib.UndirectedGraph:connect(nodeA, nodeB) ###

 Connects `nodeA` to `nodeB`


#### Undocumented methods ####

<a name="torchlib.Graph.GraphNode:toString"></a>
 * `torchlib.Graph.GraphNode:toString()`
