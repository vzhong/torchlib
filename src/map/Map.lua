--[[ Abstract map. ]]
local Map = torch.class('tl.Map')

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

function Map:tostring()
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

return Map
