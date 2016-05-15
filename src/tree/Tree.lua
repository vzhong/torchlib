local torch = require 'torch'

--- @module Tree
-- Implementation of tree.
local Tree = torch.class('tl.Tree')
local TreeNode = torch.class('tl.Tree.Node')

--- Constructor.
function TreeNode:__init(key, val)
  if val == nil then val = key end
  self.parent = nil
  self.key = key
  self.val = val
  self._size = 0
end

--- @returns {table} children of this node
function TreeNode:children()
  error('not implemented')
end

--- @returns {string} string representation
function TreeNode:__tostring__()
  return torch.type(self) .. '<' .. tostring(self.val) .. '(' .. tostring(self.key) .. ')' .. '>'
end

--- @returns {string} string representation
-- @arg {string} prefix - string to add before each line
-- @arg {boolean} isLeaf - whether the subtree is a leaf
function TreeNode:subtreeToString(prefix, isLeaf)
  prefix = prefix or ''
  isLeaf = isLeaf or true
  local s = prefix
  if isLeaf then s = s .. '|__ ' else s = s .. '|-- ' end
  s = s .. tostring(self) .. "\n"
  local newPrefix = prefix
  if isLeaf then newPrefix = newPrefix .. '    ' else newPrefix = newPrefix .. '|   ' end
  local children = self:children()
  for i = 1, #children do
    s = s .. children[i]:subtreeToString(newPrefix, false)
  end
  if #children > 0 then
    children[#children]:subtreeToString(newPrefix, true)
  end
  return string.sub(s, 0, -1)
end

--- @returns {string} string representation
function Tree:__tostring__()
  local s = torch.type(self)
  if self.root ~= nil then
    s = self.root:subtreeToString()
  end
  return s
end

--- @returns {int} number of nodes in the tree
function Tree:size()
  return self._size
end
