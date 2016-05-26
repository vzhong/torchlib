--- @module Set
-- Implementation of set.

local torch = require 'torch'
local Set, parent = torch.class('tl.Set', 'tl.Object')

--- Constructor.
-- @arg {table[any]=} values - used to initialize the set
function Set:__init(values)
  self._map = {}
  self._size = 0
  values = values or {}
  for _, v in ipairs(values) do self:add(v) end
end

--- @arg {any} val - value to produce a key for
-- @returns {torch.pointer} unique key for the value
function Set.keyOf(val)
  if torch.type(val) == 'number' or torch.type(val) == 'nil' or torch.type(val) == 'string' then
    return val
  else
    return torch.pointer(val)
  end
end

--- @returns {int} number of values in the set
function Set:size()
  return self._size
end

--- Adds a value to the set.
-- @arg {any} val - value to add to the set
-- @returns {Set} modified set
function Set:add(val)
  if not self:contains(val) then
    self._size = self._size + 1
  end
  local key = Set.keyOf(val)
  self._map[key] = val
  return self
end

--- Adds a variable number of values to the set.
-- @arg {vararg} vararg - values to add to the set
-- @returns {Set} modified set
function Set:addMany(...)
  local args = table.pack(...)
  for i, val in ipairs(args) do
    self:add(val)
  end
  return self
end

--- @returns {Set} copy of the set
function Set:copy()
  return Set.new(self:totable())
end

--- @returns {boolean} whether the set contains `val`
-- @arg {any} val - value to check for
function Set:contains(val)
  local key = Set.keyOf(val)
  return self._map[key] ~= nil
end

--- @arg {any} val - value to remove from the set.
-- @returns {Set} modified set
-- If `val` is not found then an error is raised.
function Set:remove(val)
  assert(self:contains(val) == true, 'Error: value ' .. tostring(val) .. ' not found in Set')
  local key = Set.keyOf(val)
  self._map[key] = nil
  self._size = self._size - 1
  return self
end

--- @returns {tabl} the set in table format
function Set:totable()
  local tab = {}
  for k, v in pairs(self._map) do
    table.insert(tab, v)
  end
  return tab
end

--- Compares two sets.
-- @arg {Set} another - another set
-- @returns {boolean} whether this set and `another` contain the same values
function Set:equals(another)
  if self:size() ~= another:size() then
    return false
  end

  for i, v in ipairs(another:totable()) do
    if not self:contains(v) then
      return false
    end
  end
  return true
end

--- Computes the union of two sets.
-- @arg {Set} another - another set
-- @returns {Set} a set of values that are in this set or in `another`
function Set:union(another)
  local s = self:copy()
  for i, v in ipairs(another:totable()) do
    s:add(v)
  end
  return s
end

--- Computes the intersection of two sets.
-- @arg {Set} another - another set
-- @returns {Set} a set of values that are in this set and in `another`
function Set:intersect(another)
  local s = self:copy()
  for i, v in ipairs(self:totable()) do
    if not another:contains(v) then
      s:remove(v)
    end
  end
  return s
end

--- Subtracts another set from this one.
-- @arg {Set} another - another set
-- @returns {Set} a set of values that are in this set but not in `another`
function Set:subtract(another)
  local s = self:copy()
  for i, v in ipairs(self:totable()) do
    if another:contains(v) then
      s:remove(v)
    end
  end
  return s
end

--- @returns {string} string representation
function Set:__tostring__()
  local s = parent.__tostring__(self) .. '('
  local max = 5
  local keys = self:totable()

  for i = 1, math.min(self:size(), max) do
    key = keys[i]
    s = s .. tostring(key)
    if i ~= self:size() then
      s = s .. ', '
    end
  end
  if self:size() > max then s = s .. '...' end
  s = s .. ')'
  return s
end

return Set
