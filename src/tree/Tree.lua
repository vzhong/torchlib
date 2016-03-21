--[[ Implementation of a tree. ]]
local Tree = torch.class('tl.Tree')
local TreeNode = torch.class('tl.TreeNode')

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

function TreeNode:tostring()
  return torch.type(self) .. '<' .. tostring(self.val) .. '(' .. tostring(self.key) .. ')' .. '>'
end

function TreeNode:subtreeToString(prefix, isTail)
  prefix = prefix or ''
  isTail = isTail or true
  local s = prefix
  if isTail then s = s .. '|__ ' else s = s .. '|-- ' end
  s = s .. self:tostring() .. "\n"
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

torch.getmetatable('tl.TreeNode').__tostring__ = TreeNode.tostring

function Tree:tostring()
  local s = torch.type(self)
  if self.root ~= nil then
    s = self.root:subtreeToString()
  end
  return s
end

torch.getmetatable('tl.Tree').__tostring__ = Tree.tostring

--[[ Returns the number of nodes in the tree. ]]
function Tree:size()
  return self._size
end