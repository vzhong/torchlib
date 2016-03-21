tl.util = {}
local util = tl.util

--[[ Prints table `t` with indentation for nested tables. ]]
function util.printTable(t)
    function printTableHelper(t, spacing)
        for k,v in pairs(t) do
            print(spacing..tostring(k), v)
            if (type(v) == "table") then
                printTableHelper(v, spacing.."\t")
            end
        end
    end
    printTableHelper(t, "");
end

--[[ Returns a table of indices from `from` to `to`, incrementing by `inc`. ]]
function util.range(from, to, inc)
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

--[[ Shuffles a table randomly. ]]
function util.shuffle(t)
  local iter = #t
  local j
  for i = iter, 2, -1 do
    j = math.random(i)
    t[i], t[j] = t[j], t[i] -- swap
  end
end

--[[ Returns whether two objects are equal to each other. ]]
function util.equals(a, b)
  if torch.type(a) ~= torch.type(b) then return false end
  if a.equals ~= nil and b.equals ~= nil then
    return a:equals(b)
  end
  return a == b
end

--[[ Returns whether two tables contain identical content. ]]
function util.tableEquals(t1, t2)
  for k1, v1 in pairs(t1) do
    if not util.equals(t2[k1], v1) then
      return false
    end
  end
  for k2, v2 in pairs(t2) do
    if not util.equals(t1[k2], v2) then
      return false
    end
  end
  return true
end

--[[ Returns whether two tables contain identical values. ]]
function util.tableValuesEqual(t1, t2)
  for _, v1 in pairs(t1) do
    if not util.tableContains(t2, v1) then
      return false
    end
  end
  for _, v2 in pairs(t2) do
    if not util.tableContains(t1, v2) then
      return false
    end
  end
  return true
end

--[[ Reverses `t` into a new table and returns it. ]]
function util.tableReverse(t)
  local tab = {}
  for i, e in ipairs(t) do
    table.insert(tab, 1, e)
  end
  return tab
end

--[[ Returns a copy of table `t`. ]]
function util.tableCopy(t)
  local tab = {}
  for k, v in pairs(t) do
    tab[k] = v
  end
  return tab
end

--[[ Returns whether table `t` contains the values `val`. ]]
function util.tableContains(t, val)
  for k, v in pairs(t) do
    if util.equals(v, val) then
      return true
    end
  end
  return false
end

--[[ Flattens a table. ]]
function util.tableFlatten(t, tab, prefix)
  tab = tab or {}
  prefix = prefix or ''
  for k, v in pairs(t) do
    if type(v) == 'table' then
      util.tableFlatten(v, tab, prefix..k..'__')
    else
      tab[prefix..k] = v
    end
  end
  return tab
end

--[[ Applies `callback` to each element in `t` and returns the results in another table. ]]
function util.map(t, callback)
  local results = {}
  for k, v in pairs(t) do
    results[k] = callback(v)
  end
  return results
end

--[[ Selects items with keys `keys` from table `t` and returns the results in another table.
  Options:
  - `forget_keys`: if `true` then the new table will be an array, defaults to false
]]
function util.select(t, keys, opt)
  opt = opt or {}
  local results = {}
  for _, k in ipairs(keys) do
    if opt.forget_keys then
      table.insert(results, t[k])
    else
      results[k] = t[k]
    end
  end
  return results
end

--[[ Extends the table `t` with another table `another` and returns the first table. ]]
function util.extend(t, another)
  for _, v in ipairs(another) do
    table.insert(t, v)
  end
  return t
end
