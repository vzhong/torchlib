local torch = require 'torch'

--- @module BinarySearchTree.Node
-- A node in the binary search tree.
-- This is a subclass of `BinaryTree.Node`.
local BinarySearchTree, parent = torch.class('tl.BinarySearchTree', 'tl.BinaryTree')
local BinarySearchTreeNode, parent = torch.class('tl.BinarySearchTree.Node', 'tl.BinaryTree.Node')

--- Searches for a key in the BST.
-- 
-- @arg {number} key - the key to retrieve
-- @returns {BinarySearchTree.Node} the node with the requested key
function BinarySearchTreeNode:search(key)
  local curr = self
  while curr ~= nil do
    if key == curr.key then
      return curr
    elseif key < curr.key then
      curr = curr.left
    else
      curr = curr.right
    end
  end
  return nil
end

--- @returns {int} the minimum node of the subtree rooted at this node.
function BinarySearchTreeNode:min()
  local curr = self
  while curr.left ~= nil do
    curr = curr.left
  end
  return curr
end

--- @returns {int} the maximum node of the subtree rooted at this node.
function BinarySearchTreeNode:max()
  local curr = self
  while curr.right ~= nil do
    curr = curr.right
  end
  return curr
end

--- @returns {BinarySearchTre.Node} the node with the smallest key that is larger than this one.
function BinarySearchTreeNode:successor()
  if self.right ~= nil then
    return self.right:min()
  end
  -- right subtree is nil, hence keep going up until we are on the left subtree
  local curr = self
  local p = curr.parent
  while p ~= nil and p.right == curr do
    curr = p
    p = p.parent
  end
  return p
end

--- @returns {BinarySearchTre.Node} the node with the largest key that is smaller than this one.
function BinarySearchTreeNode:predecessor()
  if self.left ~= nil then
    return self.left:max()
  end
  -- left subtree is nil, hence keep going up until we are on the right subtree
  local curr = self
  local p = curr.parent
  while p ~= nil and p.left == curr do
    curr = p
    p = p.parent
  end
  return p
end

--- @module BinarySearchTree
-- Binary Search Tree. An implementation of `BinaryTree`.
-- 
-- Example:
-- 
-- @code {lua}
-- local t = BinarySearchTree.new()
-- t:insert(BinarySearchTreeNode.new(12))
-- t:insert(BinarySearchTreeNode.new(5))
-- t:insert(BinarySearchTreeNode.new(2))
-- t:insert(BinarySearchTreeNode.new(9))
-- t:insert(BinarySearchTreeNode.new(18))
-- t:insert(BinarySearchTreeNode.new(15))
-- t:insert(BinarySearchTreeNode.new(13))
-- t:insert(BinarySearchTreeNode.new(17))
-- t:insert(BinarySearchTreeNode.new(19))
-- print(t)


--- Inserts a node into the tree.
-- @arg {BinarySearchTree.Node} node - node to insert
-- @returns {BinarySearchTree} modified tree
function BinarySearchTree:insert(node)
  local p = nil
  local curr = self.root
  while curr ~= nil do
    p = curr
    if node.key < curr.key then curr = curr.left else curr = curr.right end
  end
  node.parent = p
  if p == nil then
    self.root = node -- tree was empty
  elseif node.key < p.key then
    p.left = node
  else
    p.right = node
  end
  self._size = self._size + 1
  return self
end

--- @arg {number} key - key to search for.
-- @returns {BinarySearchTree.Node} node with the requested key
function BinarySearchTree:search(key)
  return self.root:search(key)
end

--- @returns {BinarySearchTree.Node} node with the minimum key
function BinarySearchTree:min()
  return self.root:min()
end

--- @returns {BinarySearchTree.Node} node with the maximum key
function BinarySearchTree:max()
  return self.root:max()
end

--- Replaces the subtree rooted at `old` with the one rooted at `new`.
-- @arg {BinarySearchTree.Node} old - node to replace
-- @arg {BinarySearchTree.Node} new - new node to use
-- @returns {BinarySearchTree} modified tree
function BinarySearchTree:transplant(old, new)
  if old == self.root then
    self.root = new
  elseif old == old.parent.left then
    old.parent.left = new
  else
    old.parent.right = new
  end
  if new ~= nil then
    new.parent = old.parent
  end
  return self
end

--- Deletes a node from the tree.
-- @arg {BinarySearchTree.Node} node - node to delete
-- @returns {BinarySearchTree} modified tree
function BinarySearchTree:delete(node)
  if node.left == nil then
    BinarySearchTree:transplant(node, node.right)
  elseif node.right == nil then
    BinarySearchTree:transplant(node, node.left)
  else
    local rightSubtreeMin = node.right:min()
    if rightSubtreeMin.parent ~= node then
      -- has two children and successor is not its right child
      self:transplant(rightSubtreeMin, rightSubtreeMin.right)
      rightSubtreeMin.right = node.right
      rightSubtreeMin.right.parent = rightSubtreeMin
    end
    self:transplant(node, rightSubtreeMin)
    rightSubtreeMin.left = node.left
    rightSubtreeMin.left.parent = rightSubtreeMin
  end
  self._size = self._size - 1
  return self
end

return BinarySearchTree
