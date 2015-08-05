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
end

function HashMap:contains(key)
  return self._map[key] ~= nil
end

function HashMap:get(key, default)
  if self:contains(key) then
    return self._map[key]
  else
    if default ~= nil then
      return default
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

function HashMap:toString()
  local s = torch.type(self) .. '{'
  local max = 5
  local keys = self:keySet():asTable()
  
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

torch.getmetatable('HashMap').__tostring__ = HashMap.toString
