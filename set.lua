local Set = torch.class('Set')

function Set:__init()
  self._map = {}
  self._size = 0
end

function Set.keyOf(val)
  if torch.type(val) == 'number' or torch.type(val) == 'nil' or torch.type(val) == 'string' then
    return val
  else
    return torch.pointer(val)
  end
end

function Set:size()
  return self._size
end

function Set:add(val)
  if not self:contains(val) then
    self._size = self._size + 1
  end
  key = Set.keyOf(val)
  self._map[key] = val
  return self
end

function Set:addMany(...)
  local args = table.pack(...)
  for i, val in ipairs(args) do
    self:add(val)
  end
  return self
end

function Set:copy()
  return Set.new():addMany(table.unpack(self:toTable()))
end

function Set:contains(val)
  key = Set.keyOf(val)
  return self._map[key] ~= nil
end

function Set:remove(val)
  assert(self:contains(val), 'Error: value ' .. tostring(val) .. ' not found in Set')
  key = Set.keyOf(val)
  val = self._map[key]
  self._map[key] = nil
  self._size = self._size - 1
  return self
end

function Set:toTable()
  tab = {}
  for k, v in pairs(self._map) do
    table.insert(tab, v)
  end
  return tab
end

function Set:equals(another)
  if self:size() ~= another:size() then 
    return false 
  end

  for i, v in ipairs(another:toTable()) do
    if not self:contains(v) then
      return false
    end
  end
  return true
end

function Set:union(another)
  for i, v in ipairs(another:toTable()) do
    self:add(v)
  end
  return self
end

function Set:intersect(another)
  for i, v in ipairs(self:toTable()) do
    if not another:contains(v) then
      self:remove(v)
    end
  end
  return self
end

function Set:toString()
  local s = torch.type(self) .. '('
  local max = 5
  local keys = self:toTable()
  
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

torch.getmetatable('Set').__tostring__ = Set.toString
