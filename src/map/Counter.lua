--[[ Implementation of a counter. ]]
local Counter = torch.class('tl.Counter')

--[[ Constructor. ]]
function Counter:__init()
  self.counts = {}
end

--[[ adds `count` to `key`. ]]
function Counter:add(key, count)
  count = count or 1
  if not self.counts[key] then self.counts[key] = 0 end
  self.counts[key] = self.counts[key] + count
  return self.counts[key]
end

--[[ returns the count for `key`. If `key` has not been added to the counter, then returns 0. ]]
function Counter:get(key)
  if self.counts[key] then return self.counts[key] else return 0 end
end

--[[ Removes all keys from the counter. ]]
function Counter:reset()
  self.counts = {}
end

return Counter
