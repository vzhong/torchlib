--[[ Binary Search Tree. An implementation of `BinaryTree`.

Example:

```
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
]]
local BinarySearchTree, parent = torch.class('tl.BinarySearchTree', 'tl.BinaryTree')
function BinarySearchTree:__init(key, val)
  parent:__init(key, val)
end

--[[ A node in the binary search tree, an implementation of `BinaryTreeNode`. ]]
local BinarySearchTreeNode, parent = torch.class('tl.BinarySearchTreeNode', 'tl.BinaryTreeNode')
BinarySearchTreeNode.__init = parent.__init

--[[ Searches for a key in the BST.

Parameters:
- `key`: the key to retrieve

If found, then the node with `key` is returned. Otherwise `nil` is returned.
]]
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

--[[ Returns the minimum node of the subtree rooted at this node. ]]
function BinarySearchTreeNode:min()
  local curr = self
  while curr.left ~= nil do
    curr = curr.left
  end
  return curr
end

--[[ Returns the maximum node of the subtree rooted at this node. ]]
function BinarySearchTreeNode:max()
  local curr = self
  while curr.right ~= nil do
    curr = curr.right
  end
  return curr
end

--[[ Returns the smallest node that is greater than this node. ]]
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

--[[ Returns the largest node that is smaller than this one. ]]
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

--[[ Inserts a node into the BST, starting at the root. ]]
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
  return node
end

--[[ Performs a `search` on the root node. ]]
function BinarySearchTree:search(key)
  return self.root:search(key)
end

--[[ Performs a `min` on the root node. ]]
function BinarySearchTree:min()
  return self.root:min()
end

--[[ Performs a `max` on the root node. ]]
function BinarySearchTree:max()
  return self.root:max()
end

--[[ Replaces the subtree rooted at `old` with the one rooted at `new`. ]]
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

--[[ Deletes `node` from the BST. ]]
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
