require 'xlua'

--[[ Implementation of dataset container. ]]
local Dataset = torch.class('tl.Dataset')


--[[ Constructor.
  Parameters:
  - `fields`: A table containing key value pairs.

  Each value is a list of tensors and `value[i]` contains the value corresponding to the `i`th example.

  Example:
  ```
  d = Dataset{X = X, Y = Y}
  ```
]]
function Dataset:__init(fields)
  self.fields = {}
  for k, v in pairs(fields) do
    table.insert(self.fields, k)
    self[k] = v
    if #self.fields > 1 then
      local err = 'field '..k..' has length '..#v..' but field '..self.fields[1]..' has length '..#self[self.fields[1]]
      assert(#v == #self[self.fields[1]], err)
    end
  end
end


--[[ Creates a dataset from CONLL format. The format is as follows:

```
# word  subj  subj_ner  obj obj_ner stanford_pos  stanford_ner  stanford_dep_edge stanford_dep_governor
per:city_of_birth
- - - - - : O punct 1
20  - - - - CD  DATE  ROOT  -1
: - - - - : O punct 1
Alexander SUBJECT PERSON  - - NNP PERSON  compound  4
Haig  SUBJECT PERSON  - - NNP PERSON  dep 1
, - - - - , O punct 4
US  - - - - NNP LOCATION  compound  7
secretary - - - - NN  O appos 4
...
```

That is, the first line is a tab delimited header, followed by examples separated by a blank line.
The first line of the example is the class label. The rest of the rows correspond to tokens and their associated attributes.
]]
function Dataset.from_conll(fname)
  local file = assert(io.open(fname), fname .. ' does not exist!')
  local header = file:read():split('\t')
  header[1] = header[1]:sub(3)  -- remove the '# '
  local get_fields = function()
    local fields = {}
    for _, heading in ipairs(header) do fields[heading] = {} end
    return fields
  end
  local fields = get_fields()
  fields.label = {}

  local line, linenum = file:read(), 2  -- first line's the header
  local example = get_fields()
  local labeled = false
  local submit_example = function()
    for k, v in pairs(fields) do table.insert(v, example[k]) end
    table.insert(fields.label, label)
    example = get_fields()
    labeled = false
  end
  while line do
    if #line:split('\t') == 1 and not labeled then  -- this is a label
      table.insert(fields.label, line)
      labeled = true
    elseif line == '' then  -- we just finished collecting an example
      submit_example()
    else
      local cols = line:split('\t')
      for i, heading in ipairs(header) do
        assert(cols[i], 'line '..linenum..' is missing column '..i..' ('..heading..'): '..line)
        table.insert(example[heading], cols[i])
      end
    end
    line = file:read()
    linenum = linenum + 1
  end
  submit_example()
  return Dataset.new(fields)
end


function Dataset:tostring()
  local s = "Dataset("
  for i, k in ipairs(self.fields) do
    s = s .. k
    if i < #self.fields then
      s = s .. ', '
    else
      s = s .. ') of size ' .. self:size()
    end
  end
  return s
end
torch.getmetatable('tl.Dataset').__tostring__ = Dataset.tostring

--[[ Returns the number of examples in the dataset. ]]
function Dataset:size()
  assert(#self.fields > 0, 'Dataset is empty and does not have any fields!')
  return #self[self.fields[1]]
end

--[[ Returns a table of `k` folds of the dataset. ]]
function Dataset:kfolds(k)
  local indices = torch.randperm(self:size()):long()
  return Util.map(indices:chunk(k), function(l) return l:totable() end)
end

--[[ Copies out a new Dataset which is a view into the current Dataset.
  Example:
  ```
  a, b = dataset:view(torch.IntTensor{1, 3}, torch.IntTensor{1, 2, 3})
  ```
]]
function Dataset:view(...)
  local indices = table.pack(...)
  local datasets = {}
  for i, t in ipairs(indices) do
    local fields = {}
    for _, k in ipairs(self.fields) do
      fields[k] = Util.select(self[k], t, {forget_keys=true})
    end
    table.insert(datasets, Dataset.new(fields))
  end
  return table.unpack(datasets)
end

--[[ Creates a train split and a test split given the train indices. ]]
function Dataset:train_dev_split(train_indices)
  local train = Set(train_indices)
  local all = Set(torch.range(1, self:size()):totable())
  return self:view(train:totable(), all:subtract(train):totable())
end

--[[ Reindexes the dataset accoring to the new indices. ]]
function Dataset:index(indices)
  for _, k in ipairs(self.fields) do
    local shuffled = {}
    for _, i in ipairs(indices) do
      table.insert(shuffled, self[k][i])
    end
    self[k] = shuffled
  end
  return self
end

--[[ Shuffles the dataset in place. ]]
function Dataset:shuffle()
  local indices = torch.randperm(self:size()):totable()
  return self:index(indices)
end

--[[ Sorts the examples in place by the length of the requested field. ]]
function Dataset:sort_by_length(field)
  assert(self.fields[field], field .. ' is not a valid field')
  local lengths = torch.Tensor(Util.map(self[field], function(a) return a:size(1) end))
  local sorted, indices = torch.sort(lengths)
  return self:index(indices)
end

--[[ Prepends shorter tensors in a table of tensors with `PAD` such that each tensor in the batch are of the same length.
By default `PAD` is 0.
]]
function Dataset.pad(batch, PAD)
  PAD = PAD or 0
  local lengths = torch.Tensor(Util.map(batch, function(a) return a:size(1) end))
  local min, max = lengths:min(), lengths:max()
  local X = torch.Tensor(#batch, max):fill(PAD)
  for i, x in ipairs(batch) do
    -- pad the beginning with zeros
    X[{i, {max-x:size(1)+1, max}}] = x
  end
  return X
end

--[[ Creates a batch iterator over the dataset. `batch_size` is the maximum size of each batch.

  Usage:
  ```
  d = Dataset{X=X, Y=Y}
  for batch, batch_end in d:batches(5) do
    print(batch.X)
    print(batch.Y)
  end
  ```
]]
function Dataset:batches(batch_size)
  local batch_start, batch_end = 1
  return function()
    local batch = {}
    if batch_start <= self:size() then
      batch_end = batch_start + batch_size - 1
      for _, k in ipairs(self.fields) do
        batch[k] = Util.select(self[k], Util.range(batch_start, batch_end), {forget_keys=true})
      end
      batch_start = batch_end + 1
      return batch, math.min(batch_end, self:size())
    else
      return nil
    end
  end
end

return Dataset
