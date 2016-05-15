--- @module Counter
-- Implementation of a counter.

local torch = require 'torch'
local Counter = torch.class('tl.Counter')

--- Constructor.
function Counter:__init()
  self.counts = {}
end

--- Increments the count for a key.
-- @arg {any} key - key to increment count for
-- @arg {int} count - how much to increment count by
-- @returns {int} the new count
function Counter:add(key, count)
  count = count or 1
  if not self.counts[key] then self.counts[key] = 0 end
  self.counts[key] = self.counts[key] + count
  return self.counts[key]
end

--- @arg {any} key - key to return count for.
-- @returns {int} the count for the key
--
-- If `key` has not been added to the counter, then returns 0.
function Counter:get(key)
  if self.counts[key] then return self.counts[key] else return 0 end
end

--- Clears the counter.
-- @returns {Counter} the modified counter
function Counter:reset()
  self.counts = {}
  return self
end

return Counter
