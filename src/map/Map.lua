--- @module Map
-- Abstract map implementation.

local torch = require 'torch'
local Map, parent = torch.class('tl.Map', 'tl.Object')

--- Constructor.
-- @arg {table[any:any]=} key_values - used to initialize the map
function Map:__init(key_values)
  error('not implemented')
end

--- Adds an entry to the map.
-- @arg {any} key - key to add
-- @arg {any} value - value to add
function Map:add(key, val)
  error('not implemented')
end

--- Adds many entries to the map.
-- @arg {table[any:any]=} tab - a map of key value pairs to add
function Map:addMany(tab)
  error('not implemented')
end

--- @returns {Map} copy of this map
function Map:copy()
  error('not implemented')
end

--- @returns {coolean} whether the map contains the key
-- @arg {any} key - key to check
function Map:contains(key)
  error('not implemented')
end

--- Retrieves the value for a key.
-- @arg {any} key - key to retrive
-- @arg {boolean=} returnNilIfMissing - whether to tolerate missing keys
-- @returns {any} value corresponding to the key
--
-- By default, asserts error if `key` is not found. If `returnNilIfMissing` is true,
-- then a `nil` will be returned if `key` is not found.
function Map:get(key, returnNilIfMissing)
  error('not implemented')
end

--- Removes a key value pair
-- @arg {any} key - key to remove
-- @returns {any} the removed value
--
-- Asserts error if `key` is not in the map.
function Map:remove(key)
  error('not implemented')
end

--- @returns {table[any]} a table of the keys in the map
function Map:keys()
  error('not implemented')
end

--- @returns {table[any:any]} the map in table form
function Map:totable()
  error('not implemented')
end

--- @returns {boolean} whether this map equals `another`.
-- @arg {Map} another - another map to compare to
--
-- Maps are considered equal if all keys and corresponding values match.
function Map:equals(another)
  error('not implemented')
end

--- @returns {int} number of key value pairs in the map
function Map:size()
  return self._size
end

return Map
