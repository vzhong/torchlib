local Map = torch.class('Map')

function Map:size()
  return self._size
end


local HashMap = torch.class('HashMap', 'Map')

function HashMap:__init()
  self._map = {}
  self._size = 0
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
  keys = Set.new()
  for k, v in pairs(self._map) do
    keys:add(k)
  end
  return keys
end

function HashMap:toTable()
  tab = {}
  for k, v in pairs(self._map) do
    tab[k] = v
  end
  return tab
end

function HashMap:toString()
  local s = torch.type(self) .. '{'
  local max = 5
  local keys = self:keySet():toTable()
  
  for i = 1, math.min(self:size(), max) do
    key = keys[i]
    s = s .. key .. ' -> ' .. self:get(key)
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

torch.getmetatable('HashMap').__tostring__ = HashMap.toString
