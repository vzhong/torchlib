--- @module List
-- Abstract list implementation.

local torch = require 'torch'
local List, parent = torch.class('tl.List', 'tl.Object')

--- Constructor.
-- @arg {table[any]=} values - used to initialize the list
function List:__init(values)
  error('not implemented')
end

--- Adds element to list.
-- @arg {any} val - value to add
-- @arg {int=end} index - index to add value at
-- @returns {List} - modified list
function List:add(val, index)
  error('not implemented')
end

--- @arg {int} index - index to retrieve value for
--
-- Asserts error if `index` is out of bounds.
-- @returns {any} - value at index
function List:get(index)
  error('not implemented')
end

--- Sets the value at index.
-- @arg {int} index - inde to set value for
-- @arg {any} val - value to set
-- @returns {List} - modified list
--
-- Asserts error if `index` is out of bounds.
function List:set(index, val)
  error('not implemented')
end

--- @arg {int} index - index to remove at
-- @returns {any} - value at index
--
-- Elements after `index` will be shifted to the left by 1.
-- Asserts error if `index` is out of bounds.
function List:remove(index)
  error('not implemented')
end

--- Compares two lists.
-- @arg {List} another - another list to compare to
-- @returns {boolean} whether this list is equal to `another`
--
-- Lists are considered equal if their values match at every position.
function List:equals(another)
  error('not implemented')
end

--- Swaps value at two indices.
-- @arg {int} i - first index
-- @arg {int} j - second index
-- @returns {List} - modified list
function List:swap(i, j)
  error('not implemented')
end

--- Returns the list in table form.
-- @returns {table[any]} a table containing the values in the list.
function List:totable()
  error('not implemented')
end

--- Asserts that index is inside the list.
-- @arg {int} index - index to check
function List:assertValidIndex(index)
    assert(index > 0 and index <= self:size()+1, 'index ' .. index .. ' is out of bounds for array of size ' .. self:size())
end

--- @returns {int} size of the list
function List:size()
  return self._size
end

--- Adds items to the list.
-- @arg {vararg[any]} vararg - values to add to the list
-- @returns {List} modified list
function List:addMany(...)
  local args = table.pack(...)
  for k, v in ipairs(args) do
    self:add(v)
  end
  return self
end

--- Returns whether the list contains a value.
-- @arg {any} val - value to check.
-- @returns {boolean} whether `val` is in the list
function List:contains(val)
  for i = 1, self:size() do
    if self:get(i) == val then
      return true
    end
  end
  return false
end

--- @returns {List} a copy of this list
function List:copy()
  return self.new(self:totable())
end

--- @returns {boolean} whether the list is empty
function List:isEmpty()
  return self:size() == 0
end

--- Returns a copy of a segment of this list.
-- 
-- @arg {int} start - start of the segment
-- @arg {int=end} finish - start of the segment
function List:sublist(start, finish)
  finish = finish or self:size()
  local sub = self.new()
  self:assertValidIndex(start)
  self:assertValidIndex(finish)
  for i = start, finish do sub:add(self:get(i)) end
  return sub
end

--- Sorts the list in place.
--  @arg {int=1} start - start index of the sort
--  @arg {int=end} finish - end index of the sort
function List:sort(start, finish)
  local partition = function (l, start, finish)
    local pivotIndex = math.random(start, finish)
    local pivot = self:get(pivotIndex)
    self:swap(pivotIndex, finish)
    local write = start
    for i = start, finish-1 do
      if self:get(i) < pivot then
        self:swap(i, write)
        write = write + 1
      end
    end
    self:swap(write, finish)
    return write
  end
  start = start or 1
  finish = finish or self:size()
  if start < finish then
    local pivot = partition(self, start, finish)
    self:sort(start, pivot-1)
    self:sort(pivot+1, finish)
  end
end

--- @returns {string} string representation
function List:__tostring__()
  local s = parent.__tostring__(self) .. '['
  local max = 5
  for i = 1, math.min(self:size(), max) do
    s = s .. tostring(self:get(i))
    if i == max then
      s = s .. ', ...'
    elseif i ~= self:size() then
      s = s .. ', '
    end
  end
  s = s .. ']'
  return s
end

return List
