--[[ Implementation of max heap (eg. `parent >= child`). `Heap` is a subclass of `ArrayList`. ]]
local Heap, parent = torch.class('tl.Heap', 'tl.ArrayList')

--[[ Returns the parent index of `i`. ]]
function Heap.parent(i)
  return math.floor(i/2)
end

--[[ Returns the left child index of `i`. ]]
function Heap.left(i)
  return 2 * i
end

--[[ Returns the right child index of `i`. ]]
function Heap.right(i)
  return 2 * i + 1
end

--[[ Recursively swaps down the node at `i` until the max heap condition is restored at `a[i]`.
Note: this function assumes that the binary trees rooted at left and right are max heaps but
`a[i]` may violate the max-heap condition
]]
function Heap:maxHeapify(i, effectiveSize)
  l = Heap.left(i)
  r = Heap.right(i)
  pi, vi = table.unpack(self._arr[i])
  effectiveSize = effectiveSize or self:size()
  largest = i
  plargest = pi
  if l <= effectiveSize then
    pl, vl = table.unpack(self._arr[l])
    if pl > plargest then
      plargest = pl
      largest = l
    end
  end
  if r <= effectiveSize then
    pr, vr = table.unpack(self._arr[r])
    if pr > plargest then
      plargest = pr
      largest = r
    end
  end

  if largest ~= i then
    self:swap(largest, i)
    self:maxHeapify(largest, effectiveSize)
  end
end

--[[ Sorts the heap using heap sort. ]]
function Heap:sort()
  effectiveSize = self:size()
  for i = self:size(), 2, -1 do
    self:swap(1, i) --move the largest to the end
    effectiveSize = effectiveSize - 1
    self:maxHeapify(1, effectiveSize) --swap the new head down
  end
end

--[[ Adds a `val` with priority `key` onto the heap while keeping max heap property. ]]
function Heap:push(key, val)
  if val == nil then val = key end
  self:add(table.pack(key, val), 1)
  self:maxHeapify(1)
  return self
end

--[[ Removes and returns the max key item from the heap. ]]
function Heap:pop()
  assert(not self:isEmpty(), 'Error: cannot pop from empty heap')
  self:swap(1, self:size())
  plargest, vlargest = table.unpack(self:remove(self:size()))
  if self:size() > 1 then
    self:maxHeapify(1)
  end
  return vlargest
end

--[[ Returns the max key item from the heap but does not remove it. ]]
function Heap:peek()
  assert(not self:isEmpty(), 'Error: cannot peek from empty heap')
  plargest, vlargest = table.unpack(self:get(1))
  return vlargest
end

function Heap:tostring()
  local s = 'Heap['
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

torch.getmetatable('tl.Heap').__tostring__ = Heap.tostring

return Heap
