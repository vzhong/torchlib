# BinarySearchTree.Node
A node in the binary search tree.
This is a subclass of `BinaryTree.Node`.




## BinarySearchTreeNode:search(key)
[View source](http://github.com/vzhong/torchlib/blob/master/src//tree/BinarySearchTree.lua#L13)

Searches for a key in the BST.

Arguments:

- `key ` (`number`): the key to retrieve.

Returns:

- (`BinarySearchTree.Node`) the node with the requested key

## BinarySearchTreeNode:min()
[View source](http://github.com/vzhong/torchlib/blob/master/src//tree/BinarySearchTree.lua#L28)



Returns:

- (`int`) the minimum node of the subtree rooted at this node.

## BinarySearchTreeNode:max()
[View source](http://github.com/vzhong/torchlib/blob/master/src//tree/BinarySearchTree.lua#L37)



Returns:

- (`int`) the maximum node of the subtree rooted at this node.

## BinarySearchTreeNode:successor()
[View source](http://github.com/vzhong/torchlib/blob/master/src//tree/BinarySearchTree.lua#L46)



Returns:

- (`BinarySearchTre.Node`) the node with the smallest key that is larger than this one.

## BinarySearchTreeNode:predecessor()
[View source](http://github.com/vzhong/torchlib/blob/master/src//tree/BinarySearchTree.lua#L61)



Returns:

- (`BinarySearchTre.Node`) the node with the largest key that is smaller than this one.

# BinarySearchTree
Binary Search Tree. An implementation of `BinaryTree`.

Example:



```lua
local t = BinarySearchTree.new()
t:insert(BinarySearchTreeNode.new(12))
t:insert(BinarySearchTreeNode.new(5))
t:insert(BinarySearchTreeNode.new(2))
t:insert(BinarySearchTreeNode.new(9))
t:insert(BinarySearchTreeNode.new(18))
t:insert(BinarySearchTreeNode.new(15))
t:insert(BinarySearchTreeNode.new(13))
t:insert(BinarySearchTreeNode.new(17))
t:insert(BinarySearchTreeNode.new(19))
print(t)
```

## BinarySearchTree:insert(node)
[View source](http://github.com/vzhong/torchlib/blob/master/src//tree/BinarySearchTree.lua#L97)

Inserts a node into the tree.

Arguments:

- `node ` (`BinarySearchTree.Node`): node to insert.

Returns:

- (`BinarySearchTree`) modified tree

## BinarySearchTree:search(key)
[View source](http://github.com/vzhong/torchlib/blob/master/src//tree/BinarySearchTree.lua#L118)



Arguments:

- `key ` (`number`): key to search for.

Returns:

- (`BinarySearchTree.Node`) node with the requested key

## BinarySearchTree:min()
[View source](http://github.com/vzhong/torchlib/blob/master/src//tree/BinarySearchTree.lua#L123)



Returns:

- (`BinarySearchTree.Node`) node with the minimum key

## BinarySearchTree:max()
[View source](http://github.com/vzhong/torchlib/blob/master/src//tree/BinarySearchTree.lua#L128)



Returns:

- (`BinarySearchTree.Node`) node with the maximum key

## BinarySearchTree:transplant(old, new)
[View source](http://github.com/vzhong/torchlib/blob/master/src//tree/BinarySearchTree.lua#L136)

Replaces the subtree rooted at `old` with the one rooted at `new`.

Arguments:

- `old ` (`BinarySearchTree.Node`): node to replace.
- `new ` (`BinarySearchTree.Node`): new node to use.

Returns:

- (`BinarySearchTree`) modified tree

## BinarySearchTree:delete(node)
[View source](http://github.com/vzhong/torchlib/blob/master/src//tree/BinarySearchTree.lua#L153)

Deletes a node from the tree.

Arguments:

- `node ` (`BinarySearchTree.Node`): node to delete.

Returns:

- (`BinarySearchTree`) modified tree

