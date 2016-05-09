--[[ Implementation of a variable tensor class to efficiently store tensors of varying lengths. ]]
local VariableTensor = torch.class('tl.VariableTensor', 'tl.Object')
local Dataset = tl.Dataset

require 'torch'

--[[ Constructor.

  Options:

  - `preinit_size`: how many indices to preallocate for, defaults to 1

  - `preinit_store_size`: how many elements to preallocate for, defaults to 1
]]
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
  self.write_head = 1
  self.store_write_head = 1
end

--[[ Moves the storage to cuda. ]]
function VariableTensor:cuda()
  self.store = self.store:cuda()
end

--[[ Returns the sum of the size of each tensor in the storage. ]]
function VariableTensor:size()
  return self.write_head - 1
end

--[[ Appends a tensor to the storage. ]]
function VariableTensor:push(tensor)
  while self.store_write_head + tensor:nElement() - 1 > self.store:size(1) do
    self.store:resize(self.store:size(1) * 2)
  end
  while self.write_head > self.indices:size(1) do
    self.indices:resize(self.indices:size(1) * 2, 2)
  end
  self.store[{{self.store_write_head, self.store_write_head + tensor:nElement()-1}}] = tensor
  self.indices[self.write_head][1] = self.store_write_head
  self.indices[self.write_head][2] = self.store_write_head + tensor:nElement()-1
  self.store_write_head = self.store_write_head + tensor:nElement()
  self.write_head = self.write_head + 1
end

--[[ Shuffles the indices. `indices` is an optional tensor that denotes how the new indices should be set. ]]
function VariableTensor:shuffle(indices)
  indices = indices or torch.randperm(self:size()):long()
  self.indices[{{1, self:size()}}] = self.indices[{{1, self:size()}}]:index(1, indices)
  return indices
end

--[[ Retrieves the tensor at index `i`. ]]
function VariableTensor:get(i)
  return self.store[{{self.indices[i][1], self.indices[i][2]}}]
end

--[[ Creates a zero-padded batch from tensors at the indices `indices`.

Parameters:

-`indices`: a table of integer indices.

-`pad` (default 0): the number to use to pad shorter tensors.
]]
function VariableTensor:batch(indices, pad)
  local b = {}
  for _, i in ipairs(indices) do table.insert(b, self:get(i)) end
  return Dataset.pad(b, pad)
end

return VariableTensor
