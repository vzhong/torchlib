local Tree = torch.class('Tree')
Tree.Node = torch.class('TreeNode')

function Tree.Node:__init(key, val)
  if val == nil then val = key end
  self.parent = nil
  self.key = key
  self.val = val
end

function Tree.Node:toString()
  return torch.type(self) .. '<' .. tostring(self.val) .. '(' .. tostring(self.key) .. ')' .. '>'
end

function Tree.Node:subtreeToString(prefix, isTail)
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

torch.getmetatable('TreeNode').__tostring__ = Tree.Node.toString

function Tree:toString()
  local s = torch.type(self)
  if self.root ~= nil then
    s = self.root:subtreeToString()
  end
  return s
end

torch.getmetatable('Tree').__tostring__ = Tree.toString


local BinaryTree = torch.class('BinaryTree', 'Tree')

BinaryTree.Node, parent = torch.class('BinaryTreeNode', 'TreeNode')

function BinaryTree:__init(key, val)
  parent:__init(key, val)
  self.left = nil
  self.right = nil
end

function BinaryTree.Node:children()
  local tab = {}
  if self.left ~= nil then table.insert(tab, self.left) end
  if self.right ~= nil then table.insert(tab, self.right) end
  return tab
end

function BinaryTree.Node:walkInOrder(nodes)
  if self.left ~= nil then
    self.left:walkInOrder(nodes)
  end
  table.insert(nodes, self)
  if self.right ~= nil then
    self.right:walkInOrder(nodes)
  end
end


function BinaryTree:__init()
  self.root = nil
  self._size = 0
end

function BinaryTree:walkInOrder()
  nodes = {}
  if self.root ~= nil then
    self.root:walkInOrder(nodes)
  end
  return nodes
end

function BinaryTree:size()
  return self._size
end
