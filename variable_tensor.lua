require 'torch'

local VariableTensor = torch.class('VariableTensor')

function VariableTensor:__init(opt)
  local preinit_size = 1
  local preinit_store_size = 1
  if opt and opt.preinit_size then
    preinit_size = opt.preinit_size
  end
  if opt and opt.preinit_store_size then
    preinit_store_size = opt.preinit_store_size
  end

  self.indices = torch.LongTensor(preinit_size, 2) -- start, end indices
  self.store = torch.Tensor(preinit_store_size)
  self.lengths = torch.IntTensor(preinit_size)
  self.write_head = 1
  self.store_write_head = 1
end

function VariableTensor:cuda()
  self.store = self.store:cuda()
end

function VariableTensor:size()
  return self.write_head - 1
end

function VariableTensor:push(tensor)
  while self.store_write_head + tensor:nElement() - 1 > self.store:size(1) do
    self.store:resize(self.store:size(1) * 2)
  end
  while self.write_head > self.indices:size(1) do
    self.indices:resize(self.indices:size(1) * 2, 2)
    self.lengths:resize(self.lengths:size(1) * 2)
  end
  self.store[{{self.store_write_head, self.store_write_head + tensor:nElement()-1}}] = tensor
  self.indices[self.write_head][1] = self.store_write_head
  self.indices[self.write_head][2] = self.store_write_head + tensor:nElement()-1
  self.lengths[self.write_head] = tensor:nElement()
  self.store_write_head = self.store_write_head + tensor:nElement()
  self.write_head = self.write_head + 1
end

function VariableTensor:shuffle(indices)
  indices = indices or torch.randperm(self:size())
  self.indices[{{1, self:size()}}] = self.indices[{{1, self:size()}}]:index(1, indices)
  self.lengths[{{1, self:size()}}] = self.lengths[{{1, self:size()}}]:index(1, indices)
end

function VariableTensor:length_map()
  local map = {}
  for i = 1, self:size() do
    local len = self.lengths[i]
    if not map[len] then
      map[len] = {}
    end
    table.insert(map[len], i)
  end
  local lengths = {}
  for len, indices in pairs(map) do
    table.insert(lengths, len)
    map[len] = torch.LongTensor(indices)
  end
  lengths = torch.IntTensor(lengths)
  return lengths, map
end

function VariableTensor:make_batch(len, indices)
  local batch = torch.Tensor(indices:size(1), len)
  for i = 1, indices:size(1) do
    batch[i] = self:get(indices[i])
  end
  return batch
end

do
  local lengths, map, length_idx, batch_start
  local function reset(inst)
    lengths, map = inst:length_map()
    lengths = lengths:index(1, torch.randperm(lengths:size(1)):long())
    for len, indices in pairs(map) do
      map[len] = indices:index(1, torch.randperm(indices:size(1)):long())
    end
    length_idx = 1
    batch_start = 1
  end
  function VariableTensor:get_batch_indices(batch_size)
    if not lengths then reset(self) end
    local len = lengths[length_idx]
    batch_end = math.min(batch_start + batch_size - 1, map[len]:size(1))
    local batch = map[len][{{batch_start, batch_end}}]

    batch_start = batch_end + 1
    if batch_start > map[len]:size(1) then
      -- we've exhausted all examples for this length
      length_idx = length_idx + 1
      batch_start = 1
    end
    if length_idx > lengths:size(1) then
      -- we've exhausted all the lengths
      reset(self)
      return nil, nil
    end
    return len, batch
  end
end

function VariableTensor:get(i)
  return self.store[{{self.indices[i][1], self.indices[i][2]}}]
end

return VariableTensor

