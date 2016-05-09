local M = table

--[[ Prints table `t` with indentation for nested tables. ]]
function M.tostring(t, indent, s)
  indent = indent or 0
  s = s or ''
  for k, v in pairs(t) do
    formatting = string.rep("  ", indent) .. k .. ": "
    if type(v) == "table" then
      s = s .. formatting .. '\n'
      s = M.tostring(v, indent+1, s)
    else
      s = s .. formatting .. tostring(v) .. '\n'
    end
  end
  return s
end

--[[ Shuffles a table randomly. ]]
function M.shuffle(t)
  local iter = #t
  local j
  for i = iter, 2, -1 do
    j = math.random(i)
    t[i], t[j] = t[j], t[i] -- swap
  end
end

--[[ Returns whether two tables contain identical content. ]]
function M.equals(t1, t2)
  for k1, v1 in pairs(t1) do
    if not tl.equals(t2[k1], v1) then
      return false
    end
  end
  for k2, v2 in pairs(t2) do
    if not tl.equals(t1[k2], v2) then
      return false
    end
  end
  return true
end

--[[ Returns whether two tables contain identical values. ]]
function M.valuesEqual(t1, t2)
  for _, v1 in pairs(t1) do
    if not M.contains(t2, v1) then
      return false
    end
  end
  for _, v2 in pairs(t2) do
    if not M.contains(t1, v2) then
      return false
    end
  end
  return true
end

--[[ Reverses `t` into a new table and returns it. ]]
function M.reverse(t)
  local tab = {}
  for i, e in ipairs(t) do
    table.insert(tab, 1, e)
  end
  return tab
end

--[[ Returns whether table `t` contains the values `val`. ]]
function M.contains(t, val)
  for k, v in pairs(t) do
    if tl.equals(v, val) then
      return true
    end
  end
  return false
end

--[[ Flattens a table. ]]
function M.flatten(t, tab, prefix)
  tab = tab or {}
  prefix = prefix or ''
  for k, v in pairs(t) do
    if type(v) == 'table' then
      M.flatten(v, tab, prefix..k..'__')
    else
      tab[prefix..k] = v
    end
  end
  return tab
end

--[[ Applies `callback` to each element in `t` and returns the results in another table. ]]
function M.map(t, callback)
  local results = {}
  for k, v in pairs(t) do
    results[k] = callback(v)
  end
  return results
end

--[[ Selects items with keys `keys` from table `t` and returns the results in another table.

Parameters:

  - `forget_keys` (default false): if `true` then the new table will be an array
]]
function M.select(t, keys, forget_keys)
  local results = {}
  for _, k in ipairs(keys) do
    if forget_keys then
      table.insert(results, t[k])
    else
      results[k] = t[k]
    end
  end
  return results
end

--[[ Extends the table `t` with another table `another` and returns the first table. ]]
function M.extend(t, another)
  for _, v in ipairs(another) do
    table.insert(t, v)
  end
  return t
end

--[[ Returns all combinations of elements in a table.

Example:

```
table.combinations{{1, 2}, {'a', 'b', 'c'}}
```

This returns `{{1, 'a'}, {1, 'b'}, {1, 'c'}, {2, 'a'}, {2, 'b'}, {2, 'c'}}`
]]
function M.combinations(input)
  local result = {}
  function recurse(tab, idx, ...)
    if idx < 1 then
      table.insert(result, table.pack(...))
    else
      local t = tab[idx]
      for i = 1, #t do recurse(tab, idx-1, t[i], ...) end
    end
  end

  recurse(input, #input)
  for i, t in ipairs(result) do t.n = nil end
  return result
end
