--[[ Implementation of a tree. ]]
local Tree = torch.class('Tree')
local TreeNode = torch.class('TreeNode')

function TreeNode:__init(key, val)
  if val == nil then val = key end
  self.parent = nil
  self.key = key
  self.val = val
end

--[[ Returns a table of the children of this node. ]]
function TreeNode:children()
  error('not implemented')
end

function TreeNode:toString()
  return torch.type(self) .. '<' .. tostring(self.val) .. '(' .. tostring(self.key) .. ')' .. '>'
end

function TreeNode:subtreeToString(prefix, isTail)
  prefix = prefix or ''
  isTail = isTail or true
  local s = prefix
  if isTail then s = s .. '|__ ' else s = s .. '|-- ' end
  s = s .. self:toString() .. "\n"
  local newPrefix = prefix
  if isTail then newPrefix = newPrefix .. '    ' else newPrefix = newPrefix .. '|   ' end
  local children = self:children()
  for i = 1, #children do
    s = s .. children[i]:subtreeToString(newPrefix, false)
  end
  if #children > 0 then
    children[#children]:subtreeToString(newPrefix, true)
  end
  return string.sub(s, 0, -1)
end

torch.getmetatable('TreeNode').__tostring__ = TreeNode.toString

function Tree:toString()
  local s = torch.type(self)
  if self.root ~= nil then
    s = self.root:subtreeToString()
  end
  return s
end

torch.getmetatable('Tree').__tostring__ = Tree.toString

--[[ Returns the number of nodes in the tree. ]]
function Tree:size()
  return self._size
end


--[[ Implementation of a binary tree. ]]
local BinaryTree = torch.class('BinaryTree', 'Tree')

local BinaryTreeNode, parent = torch.class('BinaryTreeNode', 'TreeNode')

function BinaryTree:__init(key, val)
  parent:__init(key, val)
  self.left = nil
  self.right = nil
end

function BinaryTreeNode:children()
  local tab = {}
  if self.left ~= nil then table.insert(tab, self.left) end
  if self.right ~= nil then table.insert(tab, self.right) end
  return tab
end

--[[ Traverses the tree in order, optionally executing `callback` at each node. ]]
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

--[[ Implementation of a binary tree. ]]
function BinaryTree:__init()
  self.root = nil
  self._size = 0
end

--[[ Traverses the binary tree starting from the root in order, optionally executing `callback` at each node. ]]
function BinaryTree:walkInOrder(callback)
  if self.root ~= nil then
    self.root:walkInOrder(callback)
  end
end
