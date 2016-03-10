--[[ Abstract map. ]]
local Map = torch.class('Map')

--[[ Constructor. `key_values` is an optional table that is used to initialize the map. ]]
function Map:__init(key_values)
  error('not implemented')
end

--[[ Adds a key value pair to the map. ]]
function Map:add(key, val)
  error('not implemented')
end

--[[ Adds many key value pairs, in the form of a table, to the map. ]]
function Map:addMany(tab)
  error('not implemented')
end

--[[ Returns a copy of this map. ]]
function Map:copy()
  error('not implemented')
end

--[[ Returns whether the map contains the key `key`. ]]
function Map:contains(key)
  error('not implemented')
end

--[[ Retrieves the value with key `key`. By default, asserts error if `key` is not found.
  if `returnNilIfMissing` is true, the a `nil` will be returned if `key` is not found. ]]
function Map:get(key, returnNilIfMissing)
  error('not implemented')
end

--[[ Removes the key value pair with key `key`. Asserts error if `key` is not in the map. ]]
function Map:remove(key)
  error('not implemented')
end

--[[ Returns a table of the keys in the map. ]]
function Map:keySet()
  error('not implemented')
end

--[[ Returns the map in table form. ]]
function Map:totable()
  error('not implemented')
end

function Map:toString()
  error('not implemented')
end

--[[ Returns whether this map equals `another`. Maps are considered equal if all keys and corresponding values match. ]]
function Map:equals(another)
  error('not implemented')
end

--[[ Returns the number of key value pairs in the map. ]]
function Map:size()
  return self._size
end

--[[ Implementation of hash map. ]]
local HashMap = torch.class('HashMap', 'Map')

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
  keys = Set.new()
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

function HashMap:toString()
  local s = torch.type(self) .. '{'
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

torch.getmetatable('HashMap').__tostring__ = HashMap.toString
