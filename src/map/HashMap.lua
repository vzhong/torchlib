--[[ Implementation of hash map. ]]
local HashMap, parent = torch.class('tl.HashMap', 'tl.Map')
local Set = tl.Set

function HashMap:__init(key_values)
  self._map = {}
  self._size = 0
  key_values = key_values or {}
  self:addMany(key_values)
end

function HashMap:add(key, val)
  if not self:contains(key) then
    self._size = self._size + 1
  end
  self._map[key] = val
  return self
end

function HashMap:addMany(tab)
  for k, v in pairs(tab) do
    self:add(k, v)
  end
  return self
end

function HashMap:copy()
  return HashMap.new():addMany(self:totable())
end

function HashMap:contains(key)
  return self._map[key] ~= nil
end

function HashMap:get(key, returnNilIfMissing)
  if self:contains(key) then
    return self._map[key]
  else
    if returnNilIfMissing ~= nil then
      return nil
    else
      error('Error: key ' .. tostring(key) .. ' not found in HashMap')
    end
  end
end

function HashMap:remove(key)
  assert(self:contains(key), 'Error: key ' .. tostring(key) .. ' not found in HashMap')
  val = self:get(key)
  self._map[key] = nil
  self._size = self._size - 1
  return val
end

function HashMap:keySet()
  local keys = Set()
  for k, v in pairs(self._map) do
    keys:add(k)
  end
  return keys
end

function HashMap:totable()
  tab = {}
  for k, v in pairs(self._map) do
    tab[k] = v
  end
  return tab
end

function HashMap:tostring()
  local s = parent.tostring(self) .. '{'
  local max = 5
  local keys = self:keySet():totable()

  for i = 1, math.min(self:size(), max) do
    key = keys[i]
    s = s .. tostring(key) .. ' -> ' .. tostring(self:get(key))
    if i ~= self:size() then
      s = s .. ', '
    end
  end
  if self:size() > max then s = s .. '...' end
  s = s .. '}'
  return s
end

function HashMap:equals(another)
  if self:size() ~= another:size() then return false end
  for k, v in pairs(self._map) do
    if v ~= another._map[k] then return false end
  end
  return true
end

torch.getmetatable('tl.HashMap').__tostring__ = HashMap.tostring

return HashMap
