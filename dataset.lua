require 'torch'

--[[ Implementation of dataset container. ]]
local Dataset = torch.class('Dataset')


--[[ Constructor.
  Parameters:
  - `X`: table of features.
  - `Y`: table of labels.
]]
function Dataset:__init(X, Y)
  self.X, self.Y = X, Y
end

function Dataset:toString()
  return "Dataset(X: " .. #self.X .. ", Y: " .. #self.Y .. ")"
end
torch.getmetatable('Dataset').__tostring__ = Dataset.toString

--[[ Returns the number of examples in the dataset. ]]
function Dataset:size()
  return #self.X
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
    table.insert(datasets, Dataset.new(Util.select(self.X, t, {forget_keys=true}), Util.select(self.Y, t, {forget_keys=true})))
  end
  return table.unpack(datasets)
end

--[[ Creates a train split and a test split given the train indices. ]]
function Dataset:train_dev_split(train_indices)
  local train = Set(train_indices)
  local all = Set(torch.range(1, self:size()):totable())
  return self:view(train:toTable(), all:subtract(train):toTable())
end

--[[ Shuffles the dataset in place. ]]
function Dataset:shuffle()
  local indices = torch.randperm(self:size()):totable()
  local X, Y = {}, {}
  for _, i in ipairs(indices) do
    table.insert(X, self.X[i])
    table.insert(Y, self.Y[i])
  end
  self.X, self.Y = X, Y
  return self
end

--[[ Sorts the examples in place by the length of the feature tensors. ]]
function Dataset:sort_by_length()
  local lengths = torch.Tensor(Util.map(self.X, function(a) return a:size(1) end))
  local sorted, indices = torch.sort(lengths)
  local X, Y = {}, {}
  for _, i in ipairs(indices:totable()) do
    table.insert(X, self.X[i])
    table.insert(Y, self.Y[i])
  end
  self.X, self.Y = X, Y
  return self
end

--[[ Prepends shorter tensors in a table of tensors with zeros such that each tensor in the batch are of the same length. ]]
function Dataset.pad(batch)
  local lengths = torch.Tensor(Util.map(batch, function(a) return a:size(1) end))
  local min, max = lengths:min(), lengths:max()
  local X = torch.Tensor(#batch, max):zero()
  for i, x in ipairs(batch) do
    -- pad the beginning with zeros
    X[{i, {max-x:size(1)+1, max}}] = x
  end
  return X
end

--[[ Creates a batch iterator over the dataset. `batch_size` is the maximum size of each batch.

  Usage:
  ```
  d = Dataset(
      {torch.IntTensor{1, 2, 3}, torch.IntTensor{5, 6, 7, 8}},
      {3, 1})
  for X, Y, batch_end in d:batches(5) do
    print(X)
    print(Y)
  end
  ```
]]
function Dataset:batches(batch_size)
  local batch_start = 1
  return function()
    if batch_start <= self:size() then
      local batch_end = batch_start + batch_size - 1
      local x = Util.select(self.X, Util.range(batch_start, batch_end), {forget_keys=true})
      local y = Util.select(self.Y, Util.range(batch_start, batch_end), {forget_keys=true})
      batch_start = batch_end + 1
      x = Dataset.pad(x)
      return x, torch.LongTensor(y), math.min(batch_end, self:size())
    else
      return nil
    end
  end
end

return {Dataset = Dataset}
