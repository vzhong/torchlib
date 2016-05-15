--- @arg {int} from - start index
-- @arg {int=end} end - end index
-- @arg {int=1} inc - value to increment by
-- @returns {table} indices from `from` to `to`, incrementing by `inc`
function tl.range(from, to, inc)
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

--- @arg {table} a - first object
-- @arg {table} b - second object
-- @returns {boolean} whether the two objects are equal to each other
function tl.equals(a, b)
  if torch.type(a) ~= torch.type(b) then return false end
  if type(a) == 'table' and a.equals ~= nil and type(b) == 'table' and b.equals ~= nil then
    return a:equals(b)
  end
  return a == b
end

--- @arg {any} t - object to copy
-- @returns {any} deep copy
--
-- from https://gist.github.com/MihailJP/3931841
function tl.deepcopy(t)
  if type(t) ~= "table" then return t end
  local meta = getmetatable(t)
  local target = {}
  for k, v in pairs(t) do
    if type(v) == "table" then
      target[k] = tl.deepcopy(v)
    else
      target[k] = v
    end
  end
  setmetatable(target, meta)
  return target
end

--- @arg {any} t - object to copy
-- @returns {any} shallow copy
function tl.copy(t)
  local tab = {}
  for k, v in pairs(t) do
    tab[k] = v
  end
  return tab
end
