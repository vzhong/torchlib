local M = tl

--[[ Returns a table of indices from `from` to `to`, incrementing by `inc`. ]]
function M.range(from, to, inc)
  inc = inc or 1
  if to == nil then
    to = from
    from = 1
  end

  local t = {}
  for i = from, to, inc do
    table.insert(t, i)
  end
  return t
end

--[[ Returns whether two objects are equal to each other. ]]
function M.equals(a, b)
  if torch.type(a) ~= torch.type(b) then return false end
  if a.equals ~= nil and b.equals ~= nil then
    return a:equals(b)
  end
  return a == b
end

--[[ Deep copies a table.
from https://gist.github.com/MihailJP/3931841
]]
function M.deepcopy(t)
  if type(t) ~= "table" then return t end
  local meta = getmetatable(t)
  local target = {}
  for k, v in pairs(t) do
    if type(v) == "table" then
      target[k] = M.deepcopy(v)
    else
      target[k] = v
    end
  end
  setmetatable(target, meta)
  return target
end

--[[ Returns a shallow copy of table `t`. ]]
function M.copy(t)
  local tab = {}
  for k, v in pairs(t) do
    tab[k] = v
  end
  return tab
end
