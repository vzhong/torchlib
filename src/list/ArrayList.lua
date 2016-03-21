--[[ Array implementation of list. ]]
local ArrayList = torch.class('tl.ArrayList', 'tl.List')

function ArrayList:__init(values)
  values = values or {}
  self._arr = Util.tableCopy(values)
  self._size = #self._arr
end

function ArrayList:add(val, index)
  if index == nil then
    table.insert(self._arr, val)
  else
    self:assertValidIndex(index)
    table.insert(self._arr, index, val)
  end
  self._size = self._size + 1
  return self
end

function ArrayList:get(index)
  self:assertValidIndex(index)
  return self._arr[index]
end

function ArrayList:set(index, val)
  self:assertValidIndex(index)
  self._arr[index] = val
  return self
end

function ArrayList:remove(index)
  self:assertValidIndex(index)
  self._size = self._size - 1
  return table.remove(self._arr, index)
end

function ArrayList:equals(another)
  if self:size() ~= another:size() then return false end
  for i = 1, self:size() do
    if self:get(i) ~= another:get(i) then return false end
  end
  return true
end

function ArrayList:swap(i, j)
  self:assertValidIndex(i)
  self:assertValidIndex(j)
  temp = self._arr[i]
  self._arr[i] = self._arr[j]
  self._arr[j] = temp
  return self
end

function ArrayList:totable()
  tab = {}
  for i = 1, self:size() do
    table.insert(tab, self._arr[i])
  end
  return tab
end

return ArrayList
