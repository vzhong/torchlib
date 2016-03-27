--[[ Linked list implementation of list. ]]
local LinkedList = torch.class('tl.LinkedList', 'tl.List')
LinkedList.Node = torch.class('tl.LinkedListNode')

function LinkedList.Node:__init(val)
  self.val = val
  self.next = nil
end

function LinkedList.Node:__tostring__()
  return 'LinkedListNode(' .. self.val .. ')'
end

function LinkedList:__init(values)
  self._sentinel = LinkedList.Node.new()
  self._tail = self._sentinel
  self._size = 0
  values = values or {}
  for _, v in ipairs(values) do
    self:add(v)
  end
end

function LinkedList:size()
  return self._size
end

--[[ Returns the head of the linked list. ]]
function LinkedList:head()
  return self._sentinel.next
end

function LinkedList:add(val, index)
  node = LinkedList.Node.new(val)
  if index == nil then
    self._tail.next = node
    self._tail = node
  else
    self:assertValidIndex(index)
    count = 1
    prev = self._sentinel
    curr = self:head()
    while count ~= index do
      prev = curr
      curr = curr.next
      count = count + 1
    end
    prev.next = node
    prev.next.next = curr
  end
  self._size = self._size + 1
  return self
end

function LinkedList:get(index)
  self:assertValidIndex(index)
  count = 1
  curr = self:head()
  while count ~= index do
    curr = curr.next
    count = count + 1
  end
  return curr.val
end

function LinkedList:set(index, val)
  self:assertValidIndex(index)
  count = 1
  curr = self:head()
  while count ~= index do
    curr = curr.next
    count = count + 1
  end
  curr.val = val
  return self
end

function LinkedList:remove(index)
  self:assertValidIndex(index)
  count = 1
  prev = self._sentinel
  curr = self:head()
  while count ~= index do
    prev = curr
    curr = curr.next
    count = count + 1
  end
  prev.next = curr.next
  if curr == self._tail then self._tail = prev end
  self._size = self._size - 1
  return curr.val
end

function LinkedList:swap(i, j)
  self:assertValidIndex(i)
  self:assertValidIndex(j)
  count = 1
  prev = self._sentinel
  curr = self:head()
  while count <= math.max(i, j) do
    if count == i then
      prevI = prev
      currI = curr
    end
    if count == j then
      prevJ = prev
      currJ = curr
    end
    count = count + 1
    prev = curr
    curr = curr.next
  end
  assert(prevI)
  assert(currI)
  assert(prevJ)
  assert(currJ)
  prevI.next = currJ
  prevJ.next = currI
  temp = currI.next
  currI.next = currJ.next
  currJ.next = temp
  return self
end

function LinkedList:equals(another)
  if self:size() ~= another:size() then return false end
  curr = self:head()
  currAnother = another:head()
  while curr ~= nil do
    if curr.val ~= currAnother.val then return false end
    curr = curr.next
    currAnother = currAnother.next
  end
  return true
end

function LinkedList:totable()
  tab = {}
  curr = self:head()
  while curr do
    table.insert(tab, curr.val)
    curr = curr.next
  end
  return tab
end

return LinkedList
