local torch = require 'torch'

--- @module BinaryTree.Node
-- Node in a binary tree.
-- This is a subclass of `Tree.Node`
local BinaryTree = torch.class('tl.BinaryTree', 'tl.Tree')
local BinaryTreeNode, parent = torch.class('tl.BinaryTree.Node', 'tl.Tree.Node')

--- Constructor
function BinaryTreeNode:__init(key, val)
  parent.__init(self, key, val)
  self.left = nil
  self.right = nil
end

--- @returns {table} children of this node
function BinaryTreeNode:children()
  local tab = {}
  if self.left ~= nil then table.insert(tab, self.left) end
  if self.right ~= nil then table.insert(tab, self.right) end
  return tab
end

--- Traverses the tree in order.
-- @arg {function=} callback - function to execute at each node
function BinaryTreeNode:walkInOrder(callback)
  callback = callback or function(node) end
  if self.left ~= nil then
    self.left:walkInOrder(callback)
  end
  callback(self)
  if self.right ~= nil then
    self.right:walkInOrder(callback)
  end
end


--- @module BinaryTree
-- Implementation of binary tree.
-- This is a subclass of `Tree`.

--- Constructor.
function BinaryTree:__init()
  self.root = nil
  self._size = 0
end

--- Traverses the binary tree starting from the root in order
-- @arg {function=} callback - function to execute at each node
function BinaryTree:walkInOrder(callback)
  if self.root ~= nil then
    self.root:walkInOrder(callback)
  end
end

return BinaryTree
