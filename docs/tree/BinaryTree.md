# BinaryTree.Node
Node in a binary tree.
This is a subclass of `Tree.Node`




## BinaryTreeNode:\_\_init(key, val)
[View source](http://github.com/vzhong/torchlib/blob/master/src//tree/BinaryTree.lua#L10)

Constructor


## BinaryTreeNode:children()
[View source](http://github.com/vzhong/torchlib/blob/master/src//tree/BinaryTree.lua#L17)



Returns:

- (`table`) children of this node

## BinaryTreeNode:walkInOrder(callback)
[View source](http://github.com/vzhong/torchlib/blob/master/src//tree/BinaryTree.lua#L26)

Traverses the tree in order.

Arguments:

- `callback ` (`function`): function to execute at each node. Optional.


# BinaryTree
Implementation of binary tree.
This is a subclass of `Tree`.




## BinaryTree:\_\_init()
[View source](http://github.com/vzhong/torchlib/blob/master/src//tree/BinaryTree.lua#L43)

Constructor.


## BinaryTree:walkInOrder(callback)
[View source](http://github.com/vzhong/torchlib/blob/master/src//tree/BinaryTree.lua#L50)

Traverses the binary tree starting from the root in order

Arguments:

- `callback ` (`function`): function to execute at each node. Optional.


