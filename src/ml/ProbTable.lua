--[[ Implementation of probability table using Torch tensor. ]]
local ProbTable = torch.class('tl.ProbTable')

--[[ Constructor.

Parameters:

- `P`: probability Tensor, the `i`th dimension corresponds to the `i`th variable.

- `names` (optional): A table of names for the variables. By default theses will be assigned using indices.


Example:

```
local t = ProbTable(torch.Tensor{{0.2, 0.8}, {0.4, 0.6}, {0.1, 0.9}}, {'a', 'b'})
t:query{a=1, b=2}  -- 0.8
t:query{a=2}  -- Tensor{0.4, 0.6}
```
]]
function ProbTable:__init(P, names)
  if not names then names = torch.range(1, P:nDimension()):totable() end
  self.names = {}
  self.name2index = {}
  if type(names) == 'string' then
    self.names = {names}
    self.name2index = {}
    self.name2index[names] = 1
  else
    for _, name in ipairs(names) do
      table.insert(self.names, name)
      self.name2index[name] = #self.names
    end
  end
  self.P = P
end

--[[ Returns the number of variables in the table. ]]
function ProbTable:size()
  return self.P:nDimension()
end

--[[ Returns the probabilities for the assignments in `dict`.

Example:

```
local t = ProbTable(torch.Tensor{{0.2, 0.8}, {0.4, 0.6}, {0.1, 0.9}}, {'a', 'b'})
t:query{a=1, b=2}  -- 0.8
t:query{a=2}  -- Tensor{0.4, 0.6}
```
]]
function ProbTable:query(dict)
  for name, value in pairs(dict) do
    local i = assert(self.name2index[name], name .. ' is not a valid name')
    assert(value > 0 and value <= self.P:size(i), value .. ' is out of range')
  end
  local ind = {}
  for i, name in ipairs(self.names) do
    table.insert(ind, dict[name] or {})
  end
  return self.P[ind]
end

--[[ Returns a copy. ]]
function ProbTable:clone()
  local names = tl.copy(self.names)
  local P = self.P:clone()
  return ProbTable.new(P, names)
end

function ProbTable:__tostring__()
  local s = ''
  local divider = ''
  for i, name in ipairs(self.names) do
    s = s .. name .. '\t'
    divider = divider .. '-' .. '\t'
  end
  s = s .. 'P\n' .. divider .. '-\n'
  local dims = self.P:size():totable()
  for i, d in ipairs(dims) do
    dims[i] = torch.range(1, d):totable()
  end
  for _, ind in ipairs(tl.table.combinations(dims)) do
    for _, i in ipairs(ind) do
      s = s .. i .. '\t'
    end
    s = s .. self.P[ind] .. '\n'
  end
  return s
end

--[[ Returns a new table that is the product of two tables. ]]
function ProbTable:mul(B)
  -- allocate new P and name for the new product ProbTable
  local P = self.P:clone()
  local names = tl.copy(self.names)
  local name2index = tl.copy(self.name2index)

  -- the idea is that we will extend the new name order such that
  -- the beginning names are in the exact same order as B.names.
  -- this way B.P[ind] can be multiplied with P[ind] directly.
  -- we also do this because repeatTensor repeats from the beginning dimensions.
  local write = 1  -- This keep track of the index of the first non-B name
  for i, name in ipairs(B.names) do
    if name2index[name] then
      -- This name is in both A and B, so we swap it to beginning
      -- swap P
      local old_i = name2index[name]
      P = P:transpose(old_i, write)
      -- swap name
      local old_write_name = names[write]
      names[write] = name
      names[old_i] = old_write_name
      -- swap name2index
      name2index[old_write_name] = old_i
      name2index[name] = write
    else
      -- Otherwise this name is in B only, we simply insert it into the correct spot
      table.insert(names, write, name)
      for i, name in ipairs(names) do name2index[name] = i end
      local sizes = torch.ones(P:nDimension() + 1)
      sizes[1] = B.P:size(i)
      P = P:repeatTensor(table.unpack(sizes:totable())):transpose(1, write)
    end
    write = write + 1
  end
  local dims = B.P:size():totable()
  for i, d in ipairs(dims) do dims[i] = torch.range(1, d):totable() end
  for _, ind in ipairs(tl.table.combinations(dims)) do
    if type(P[ind]) == 'number' then
      P[ind] = P[ind] * B.P[ind]
    else
      P[ind]:mul(B.P[ind])
    end
  end
  return ProbTable.new(P, names)
end

--[[ Returns this probability table with the variable `name` marginalized out. ]]
function ProbTable:marginalize(name)
  local dim = assert(self.name2index[name], tostring(name) .. ' is not a valid name')
  self.P = self.P:sum(dim):squeeze(dim)
  if type(self.P) == 'number' then self.P = torch.Tensor{self.P} end
  self.name2index[name] = nil
  for i = dim, #self.names do
    self.names[i] = self.names[i+1]
    if self.names[i+1] then
      self.name2index[self.names[i+1]] = i
    end
  end
  return self
end

--[[ Returns the marginal for variable of `name` by marginalizing out every other variable. ]]
function ProbTable:marginal(name)
  assert(self.name2index[name], 'Table does not contain variable with name '..name)
  while self:size() > 1 do
    for i = 1, self:size() do
      if self.names[i] ~= name then
        self:marginalize(self.names[i])
        break
      end
    end
  end
  return self
end

--[[ Normalizes this table by dividing by the sum of all probabilities. ]]
function ProbTable:normalize()
  self.P:div(self.P:sum())
  return self
end

return ProbTable
