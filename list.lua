local List = torch.class('List')

function List:assertValidIndex(index)
    assert(index > 0 and index <= self:size()+1, 'index ' .. index .. ' is out of bounds for array of size ' .. self:size())
end

function List:size()
  return self._size
end

function List:addMany(...)
  local args = table.pack(...)
  for k, v in ipairs(args) do
    self:add(v)
  end
  return self
end

function List:contains(val)
  for i = 1, self:size() do
    if self:get(i) == val then
      return true
    end
  end
  return false
end

function List:isEmpty()
  return self:size() == 0
end

function List:toString()
  local s = torch.type(self) .. '['
  local max = 5
  
  for i = 1, math.min(self:size(), max) do
    s = s .. self:get(i)
    if i ~= self:size() then
      s = s .. ', '
    end
  end
  if self:size() > max then s = s .. '...' end
  s = s .. ']'
  return s
end

torch.getmetatable('List').__tostring__ = List.toString


local ArrayList = torch.class('ArrayList', 'List')

function ArrayList:__init()
  self._arr = {}
  self._size = 0
end

function ArrayList:add(val, index)
  if index == nil then
    table.insert(self._arr, val)
  else
    assert(index > 0 and index <= self:size(), 'index ' .. index .. ' is out of bounds for array of size ' .. self:size())
    table.insert(self._arr, index, val)
  end
  self._size = self._size + 1
  return self
end

function ArrayList:get(index)
  self:assertValidIndex(index)
  return self._arr[index]
end

function ArrayList:remove(index)
  self:assertValidIndex(index)
  self._size = self._size - 1
  return table.remove(self._arr, index)
end


local LinkedList = torch.class('LinkedList', 'List')
LinkedList.Node = torch.class('LinkedListNode')

function LinkedList.Node:__init(val)
  self.val = val
  self.next = nil
end

function LinkedList.Node.toString()
  return 'LinkedListNode(' .. self.val .. ')'
end

torch.getmetatable('LinkedListNode').__tostring__ = LinkedList.Node.toString

function LinkedList:__init()
  self._sentinel = LinkedList.Node.new()
  self._tail = self._sentinel
  self._size = 0
end

function LinkedList:size()
  return self._size
end

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
  self._size = self._size - 1
  return curr.val
end

