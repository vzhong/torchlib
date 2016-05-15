--- @module Heap
-- Max heap implementation.
-- This is a subclass of `List`.

local Heap, parent = torch.class('tl.Heap', 'tl.ArrayList')
local Object = tl.Object

--- @returns {int} parent index of `i`
-- @arg {int} i - index to compute parent for
function Heap.parent(i)
  return math.floor(i/2)
end

--- @returns {int} left child index of `i`
-- @arg {int} i - index to compute left child for
function Heap.left(i)
  return 2 * i
end

--- @returns {int} right child index of `i`
-- @arg {int} i - index to compute right child for
function Heap.right(i)
  return 2 * i + 1
end

--- Restores max heap condition at the `i`th index.
--
-- @arg {int} i - index at which to restore max heap condition
-- @arg {int=size} effectiveSize - effective size of the heap (eg. number of valid elements)
-- @returns {Heap} modified heap
--
-- Recursively swaps down the node at `i` until the max heap condition is restored at `a[i]`.
-- Note: this function assumes that the binary trees rooted at left and right are max heaps but
-- `a[i]` may violate the max-heap condition.
function Heap:maxHeapify(i, effectiveSize)
  local l = Heap.left(i)
  local r = Heap.right(i)
  local pi, vi = table.unpack(self._arr[i])
  effectiveSize = effectiveSize or self:size()
  local largest = i
  local plargest = pi
  if l <= effectiveSize then
    local pl, vl = table.unpack(self._arr[l])
    if pl > plargest then
      plargest = pl
      largest = l
    end
  end
  if r <= effectiveSize then
    local pr, vr = table.unpack(self._arr[r])
    if pr > plargest then
      -- plargest = pr
      largest = r
    end
  end

  if largest ~= i then
    self:swap(largest, i)
    self:maxHeapify(largest, effectiveSize)
  end
end

--- Sorts the heap using heap sort.
-- @returns {Heap} sorted heap
function Heap:sort()
  local effectiveSize = self:size()
  for i = self:size(), 2, -1 do
    self:swap(1, i) --move the largest to the end
    effectiveSize = effectiveSize - 1
    self:maxHeapify(1, effectiveSize) --swap the new head down
  end
  return self
end

--- Adds an element to the heap while keeping max heap property.
-- @arg {number} key - priority to add with
-- @arg {any} val - element to add to heap
-- @returns {Heap} modified heap
function Heap:push(key, val)
  if val == nil then val = key end
  self:add(table.pack(key, val), 1)
  self:maxHeapify(1)
  return self
end

--- Removes and returns the max priority element from the heap.
-- @returns {any} removed element
function Heap:pop()
  assert(not self:isEmpty(), 'Error: cannot pop from empty heap')
  self:swap(1, self:size())
  local plargest, vlargest = table.unpack(self:remove(self:size()))
  if self:size() > 1 then
    self:maxHeapify(1)
  end
  return vlargest
end

--- @return {any} max priority element from the heap
-- 
-- Note: the element is not removed.
function Heap:peek()
  assert(not self:isEmpty(), 'Error: cannot peek from empty heap')
  local plargest, vlargest = table.unpack(self:get(1))
  return vlargest
end

function Heap:__tostring__()
  local s = Object.__tostring__(self) .. '['
  local max = 5
  for i = 1, math.min(self:size(), max) do
    local p, v = table.unpack(self:get(i))
    s = s .. tostring(v) .. '(' .. p .. ')'
    if i == max then
      s = s .. ', ...'
    elseif i ~= self:size() then
      s = s .. ', '
    end
  end
  s = s .. ']'
  return s
end

return Heap
