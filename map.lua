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
      error('key ' .. key .. ' not found in HashMap')
    end
  end
end

function HashMap:remove(key)
  assert(self:contains(key), 'key ' .. key .. ' not found in HashMap')
  val = self:get(key)
  self._map[key] = nil
  self._size = self._size - 1
  return val
end

