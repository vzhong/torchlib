--[[ Abstract list. ]]
local List = torch.class('tl.List')

--[[ Constructor. `values` is an optional table used to initialize the list. ]]
function List:__init(values)
  error('not implemented')
end

--[[ Adds `val` to list at index `index`. By defalut `index` defaults to the last element. ]]
function List:add(val, index)
  error('not implemented')
end

--[[ Returns the value at index `index`. Asserts error if `index` is out of bounds. ]]
function List:get(index)
  error('not implemented')
end

--[[ Sets the value at index `index` to `val`. Asserts error if `index` is out of bounds. ]]
function List:set(index, val)
  error('not implemented')
end

--[[ Removes the value at index `index`. Elements after `index` will be shifted to the left by 1. Asserts error if `index` is out of bounds. ]]
function List:remove(index)
  error('not implemented')
end

--[[ Returns whether this list is equal to `another`. Lists are considered equal if their values match at every position. ]]
function List:equals(another)
  error('not implemented')
end

--[[ Swaps the value at `i` with the value at `j`. ]]
function List:swap(i, j)
  error('not implemented')
end

--[[ Returns the list in table form. ]]
function List:totable()
  error('not implemented')
end

--[[ Asserts that `index` is inside the list. ]]
function List:assertValidIndex(index)
    assert(index > 0 and index <= self:size()+1, 'index ' .. index .. ' is out of bounds for array of size ' .. self:size())
end

--[[ Returns the size of the list. ]]
function List:size()
  return self._size
end

--[[ Adds a variable number of items to the list. ]]
function List:addMany(...)
  local args = table.pack(...)
  for k, v in ipairs(args) do
    self:add(v)
  end
  return self
end

--[[ Returns whether `val` is in the list. ]]
function List:contains(val)
  for i = 1, self:size() do
    if self:get(i) == val then
      return true
    end
  end
  return false
end

--[[ Returns a copy of this list. ]]
function List:copy()
  return self.new(self.totable())
end

--[[ Returns whether the list is empty. ]]
function List:isEmpty()
  return self:size() == 0
end

--[[ Returns a new list containing a consecutive run from this list.

Parameters:
- `start`: the start of the run
- `finish` (optional): the end of the run, defaults to the end of the list
]]
function List:sublist(start, finish)
  finish = finish or self:size()
  local sub = self.new()
  self:assertValidIndex(start)
  self:assertValidIndex(finish)
  for i = start, finish do sub:add(self:get(i)) end
  return sub
end

--[[ Sorts the list in place.
  Parameters:
  - `start` (optional): the start of the sort, defaults to 1
  - `finish` (optional): the end of the sort, defaults to the end of the list
]]
function List:sort(start, finish)
  function partition(l, start, finish)
    pivotIndex = math.random(start, finish)
    pivot = self:get(pivotIndex)
    self:swap(pivotIndex, finish)
    write = start
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
    pivot = partition(self, start, finish)
    self:sort(start, pivot-1)
    self:sort(pivot+1, finish)
  end
end

function List:tostring()
  local s = torch.type(self) .. '['
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

torch.getmetatable('tl.List').__tostring__ = List.tostring

return List
