Heap, parent = torch.class('Heap', 'ArrayList')

-- a Max Heap where parent >= child

function Heap.parent(i)
  return math.floor(i/2)
end

function Heap.left(i)
  return 2 * i
end

function Heap.right(i)
  return 2 * i + 1
end

function Heap:maxHeapify(i, effectiveSize)
  -- assumption: the binary trees rooted at left and right are max heaps but a[i] may violate the max-heap condition
  -- recursively swap down the node at i until max heap condition is restored at a[i]
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

function Heap:sort()
  -- heapsort algorithm
  effectiveSize = self:size()
  for i = self:size(), 2, -1 do
    self:swap(1, i) --move the largest to the end
    effectiveSize = effectiveSize - 1
    self:maxHeapify(1, effectiveSize) --swap the new head down
  end
end

function Heap:push(key, val)
  -- adds a value with priority key and maintains max heap property
  if val == nil then val = key end
  self:add(table.pack(key, val), 1)
  self:maxHeapify(1)
  return self
end

function Heap:pop()
  -- removes the max key item from the heap and return it
  assert(not self:isEmpty(), 'Error: cannot pop from empty heap')
  self:swap(1, self:size())
  plargest, vlargest = table.unpack(self:remove(self:size()))
  if self:size() > 1 then
    self:maxHeapify(1)
  end
  return vlargest
end

function Heap:peek()
  -- returns the max key item from the heap but does not remove it
  assert(not self:isEmpty(), 'Error: cannot peek from empty heap')
  plargest, vlargest = table.unpack(self:get(1))
  return vlargest
end

function Heap:toString()
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

torch.getmetatable('Heap').__tostring__ = Heap.toString
