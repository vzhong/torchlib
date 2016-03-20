--[[ Implementation of set. ]]
local Set = torch.class('Set')

--[[ Constructor. `values` is an optional table of values that is used to initialize the set. ]]
function Set:__init(values)
  self._map = {}
  self._size = 0
  values = values or {}
  self:addMany(table.unpack(values))
end

--[[ Returns a unique key for a value. ]]
function Set.keyOf(val)
  if torch.type(val) == 'number' or torch.type(val) == 'nil' or torch.type(val) == 'string' then
    return val
  else
    return torch.pointer(val)
  end
end

--[[ Returns the number of values in the set. ]]
function Set:size()
  return self._size
end

--[[ Adds a value to the set. ]]
function Set:add(val)
  if not self:contains(val) then
    self._size = self._size + 1
  end
  key = Set.keyOf(val)
  self._map[key] = val
  return self
end

--[[ Adds a variable number of values to the set. ]]
function Set:addMany(...)
  local args = table.pack(...)
  for i, val in ipairs(args) do
    self:add(val)
  end
  return self
end

--[[ Returns a copy of the set. ]]
function Set:copy()
  return Set.new():addMany(table.unpack(self:totable()))
end

--[[ Returns whether the set contains `val`. ]]
function Set:contains(val)
  key = Set.keyOf(val)
  return self._map[key] ~= nil
end

--[[ Removes `val` from the set. If `val` is not found then an error is raised. ]]
function Set:remove(val)
  assert(self:contains(val), 'Error: value ' .. tostring(val) .. ' not found in Set')
  key = Set.keyOf(val)
  val = self._map[key]
  self._map[key] = nil
  self._size = self._size - 1
  return self
end

--[[ Returns the set in table format. ]]
function Set:totable()
  tab = {}
  for k, v in pairs(self._map) do
    table.insert(tab, v)
  end
  return tab
end

--[[ Returns whether the set is equal to `another`. Sets are considered equal if the values contained are identical. ]]
function Set:equals(another)
  if self:size() ~= another:size() then
    return false
  end

  for i, v in ipairs(another:totable()) do
    if not self:contains(v) then
      return false
    end
  end
  return true
end

--[[ Returns the union of this set and `another`. ]]
function Set:union(another)
  local s = self:copy()
  for i, v in ipairs(another:totable()) do
    s:add(v)
  end
  return s
end

--[[ Returns the intersection of this set and `another`. ]]
function Set:intersect(another)
  local s = self:copy()
  for i, v in ipairs(self:totable()) do
    if not another:contains(v) then
      s:remove(v)
    end
  end
  return s
end

--[[ Returns a set of values that are in this set but not in `another`. ]]
function Set:subtract(another)
  local s = self:copy()
  for i, v in ipairs(self:totable()) do
    if another:contains(v) then
      s:remove(v)
    end
  end
  return s
end


function Set:tostring()
  local s = torch.type(self) .. '('
  local max = 5
  local keys = self:totable()

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

torch.getmetatable('Set').__tostring__ = Set.tostring
