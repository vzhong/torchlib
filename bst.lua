local BinarySearchTree = torch.class('BinarySearchTree', 'BinaryTree')

BinarySearchTree.Node = torch.class('BinarySearchTreeNode', 'BinaryTreeNode')

function BinarySearchTree.Node:search(key)
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

function BinarySearchTree.Node:min()
  local curr = self
  while curr.left ~= nil do
    curr = curr.left
  end
  return curr
end

function BinarySearchTree.Node:max()
  local curr = self
  while curr.right ~= nil do
    curr = curr.right
  end
  return curr
end

function BinarySearchTree.Node:successor()
  -- returns the smallest node that is greater than this one
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

function BinarySearchTree.Node:predecessor()
  -- returns the largest node that is smaller than this one
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

function BinarySearchTree:search(key)
  return self.root:search(key)
end

function BinarySearchTree:min()
  return self.root:min()
end

function BinarySearchTree:max()
  return self.root:max()
end

function BinarySearchTree:transplant(old, new)
  -- replaces the subtree rooted at old with one rooted at new
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

function BinarySearchTree:delete(node)
  if node.left == nil then
    BinarySearchTree:transplant(node, node.right)
  elseif node.right == nil then
    BinarySearchTree:transplant(node, node.right)
  else
    local rightSubtreeMin = node.right:minimum()
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

function BinarySearchTree.fake()
  local t = BinarySearchTree.new()
  t:insert(BinarySearchTree.Node.new(12))
  t:insert(BinarySearchTree.Node.new(5))
  t:insert(BinarySearchTree.Node.new(2))
  t:insert(BinarySearchTree.Node.new(9))
  t:insert(BinarySearchTree.Node.new(18))
  t:insert(BinarySearchTree.Node.new(15))
  t:insert(BinarySearchTree.Node.new(13))
  t:insert(BinarySearchTree.Node.new(17))
  t:insert(BinarySearchTree.Node.new(19))
  return t
end

