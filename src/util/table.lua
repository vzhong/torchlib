--- @arg {table} t - a table
-- @arg {string=} indent - indentation for nested keys
-- @arg {string=} s - accumulated string
--@returns {string} string representation for the table
function table.tostring(t, indent, s)
  indent = indent or 0
  s = s or ''
  for k, v in pairs(t) do
    formatting = string.rep("  ", indent) .. k .. ": "
    if type(v) == "table" then
      s = s .. formatting .. '\n'
      s = table.tostring(v, indent+1, s)
    else
      s = s .. formatting .. tostring(v) .. '\n'
    end
  end
  return s
end

--- @arg {table} t - table to shuffle in place
-- @returns {table} shuffled table
function table.shuffle(t)
  local iter = #t
  local j
  for i = iter, 2, -1 do
    j = math.random(i)
    t[i], t[j] = t[j], t[i] -- swap
  end
  return t
end

--- @arg {table[any]} t1 - first table
-- @arg {table[any]} t2 - seoncd table
-- @returns {boolean} whether the keys and values of each table are equal
function table.equals(t1, t2)
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

--- @arg {table[any]} t1 - first table
-- @arg {table[any]} t2 - seoncd table
-- @returns {boolean} whether the values of each table are equal, disregarding order
function table.valuesEqual(t1, t2)
  for _, v1 in pairs(t1) do
    if not table.contains(t2, v1) then
      return false
    end
  end
  for _, v2 in pairs(t2) do
    if not table.contains(t1, v2) then
      return false
    end
  end
  return true
end

--- @arg {table} t - table to reverse
-- @returns {table} A copy of the table, reversed.
function table.reverse(t)
  local tab = {}
  for i, e in ipairs(t) do
    table.insert(tab, 1, e)
  end
  return tab
end

--- @arg {table} t - table to check
-- @arg {any} val - value to check
-- @returns {boolean} whether the tabale contains the value
function table.contains(t, val)
  for k, v in pairs(t) do
    if tl.equals(v, val) then
      return true
    end
  end
  return false
end

--- Flattens the table.
-- @arg {table} t - the table to modify
-- @arg {table=} tab - where to store the results. If not given, then a new table will be used.
-- @arg {string='__'} prefix - string to use to join nested keys.
-- @returns {table} flattened table
function table.flatten(t, tab, prefix)
  tab = tab or {}
  prefix = prefix or ''
  for k, v in pairs(t) do
    if type(v) == 'table' then
      table.flatten(v, tab, prefix..k..'__')
    else
      tab[prefix..k] = v
    end
  end
  return tab
end

--- Applies `callback` to each element in `t` and returns the results in another table.
-- @arg {table} t - the table to modify
-- @arg {function} callback - function to apply
-- @returns {table} modified table
function table.map(t, callback)
  local results = {}
  for k, v in pairs(t) do
    results[k] = callback(v)
  end
  return results
end

--- Selects items from table `t`.
-- @arg {table} t - table to select from
-- @arg {table} keys - table of keys
-- @arg {boolean=} forget_keys - whether to retain the keys
-- @returns {table} a table of key value pairs where the keys are `keys` and the values are corresponding values from `t`.
--
-- If `forget_keys` is `true`, then the returned table will have integer keys.
function table.select(t, keys, forget_keys)
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

--- Extends the table `t` with another table `another`
-- @arg {table} t - first table
-- @arg {table} another - second table
-- @returns {table} modified first table
function table.extend(t, another)
  for _, v in ipairs(another) do
    table.insert(t, v)
  end
  return t
end

--- Returns all combinations of elements in a table.
-- 
-- @arg {table[table[any]]} input - a collection of lists to compute the combination for
-- @returns {table[table[any]]} combinations of the input
-- 
-- Example:
-- 
-- @code
-- table.combinations{{1, 2}, {'a', 'b', 'c'}}
-- 
-- This returns `{{1, 'a'}, {1, 'b'}, {1, 'c'}, {2, 'a'}, {2, 'b'}, {2, 'c'}}`
function table.combinations(input)
  local result = {}
  local recurse
  recurse = function(tab, idx, ...)
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
