<a name="torchlib.BinarySearchTree.dok"></a>


## torchlib.BinarySearchTree ##

 Binary Search Tree. An implementation of `BinaryTree`. 
<a name="torchlib.BinarySearchTreeNode.dok"></a>


## torchlib.BinarySearchTreeNode ##

 A node in the binary search tree, an implementation of `BinaryTreeNode`. 

<a class="entityLink" href="https://github.com/vzhong/torchlib/blob/975ba472d6e4fdaa1f6c82e04d3ff16b691aaa02/bst.lua#L18">[src]</a>
<a name="torchlib.BinarySearchTreeNode:search"></a>


### torchlib.BinarySearchTreeNode:search(key) ###

 Searches for a key in the BST.

Parameters:
- `key`: the key to retrieve

If found, then the node with `key` is returned. Otherwise `nil` is returned.


<a class="entityLink" href="https://github.com/vzhong/torchlib/blob/975ba472d6e4fdaa1f6c82e04d3ff16b691aaa02/bst.lua#L33">[src]</a>
<a name="torchlib.BinarySearchTreeNode:min"></a>


### torchlib.BinarySearchTreeNode:min() ###

 Returns the minimum node of the subtree rooted at this node. 

<a class="entityLink" href="https://github.com/vzhong/torchlib/blob/975ba472d6e4fdaa1f6c82e04d3ff16b691aaa02/bst.lua#L42">[src]</a>
<a name="torchlib.BinarySearchTreeNode:max"></a>


### torchlib.BinarySearchTreeNode:max() ###

 Returns the maximum node of the subtree rooted at this node. 

<a class="entityLink" href="https://github.com/vzhong/torchlib/blob/975ba472d6e4fdaa1f6c82e04d3ff16b691aaa02/bst.lua#L51">[src]</a>
<a name="torchlib.BinarySearchTreeNode:successor"></a>


### torchlib.BinarySearchTreeNode:successor() ###

 Returns the smallest node that is greater than this node. 

<a class="entityLink" href="https://github.com/vzhong/torchlib/blob/975ba472d6e4fdaa1f6c82e04d3ff16b691aaa02/bst.lua#L66">[src]</a>
<a name="torchlib.BinarySearchTreeNode:predecessor"></a>


### torchlib.BinarySearchTreeNode:predecessor() ###

 Returns the largest node that is smaller than this one. 

<a class="entityLink" href="https://github.com/vzhong/torchlib/blob/975ba472d6e4fdaa1f6c82e04d3ff16b691aaa02/bst.lua#L81">[src]</a>
<a name="torchlib.BinarySearchTree:insert"></a>


### torchlib.BinarySearchTree:insert(node) ###

 Inserts a node into the BST, starting at the root. 

<a class="entityLink" href="https://github.com/vzhong/torchlib/blob/975ba472d6e4fdaa1f6c82e04d3ff16b691aaa02/bst.lua#L101">[src]</a>
<a name="torchlib.BinarySearchTree:search"></a>


### torchlib.BinarySearchTree:search(key) ###

 Performs a `search` on the root node. 

<a class="entityLink" href="https://github.com/vzhong/torchlib/blob/975ba472d6e4fdaa1f6c82e04d3ff16b691aaa02/bst.lua#L106">[src]</a>
<a name="torchlib.BinarySearchTree:min"></a>


### torchlib.BinarySearchTree:min() ###

 Performs a `min` on the root node. 

<a class="entityLink" href="https://github.com/vzhong/torchlib/blob/975ba472d6e4fdaa1f6c82e04d3ff16b691aaa02/bst.lua#L111">[src]</a>
<a name="torchlib.BinarySearchTree:max"></a>


### torchlib.BinarySearchTree:max() ###

 Performs a `max` on the root node. 

<a class="entityLink" href="https://github.com/vzhong/torchlib/blob/975ba472d6e4fdaa1f6c82e04d3ff16b691aaa02/bst.lua#L116">[src]</a>
<a name="torchlib.BinarySearchTree:transplant"></a>


### torchlib.BinarySearchTree:transplant(old, new) ###

 Replaces the subtree rooted at `old` with the one rooted at `new`. 

<a class="entityLink" href="https://github.com/vzhong/torchlib/blob/975ba472d6e4fdaa1f6c82e04d3ff16b691aaa02/bst.lua#L131">[src]</a>
<a name="torchlib.BinarySearchTree:delete"></a>


### torchlib.BinarySearchTree:delete(node) ###

 Deletes `node` from the BST. 

<a class="entityLink" href="https://github.com/vzhong/torchlib/blob/975ba472d6e4fdaa1f6c82e04d3ff16b691aaa02/bst.lua#L153">[src]</a>
<a name="torchlib.BinarySearchTree.fake"></a>


### torchlib.BinarySearchTree.fake() ###

 Generates a dummy BST. 


#### Undocumented methods ####

<a name="torchlib.BinarySearchTree"></a>
 * `torchlib.BinarySearchTree(key, val)`
