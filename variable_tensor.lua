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
  end
  self.store[{{self.store_write_head, self.store_write_head + tensor:nElement()-1}}] = tensor
  self.indices[self.write_head][1] = self.store_write_head
  self.indices[self.write_head][2] = self.store_write_head + tensor:nElement()-1
  self.store_write_head = self.store_write_head + tensor:nElement()
  self.write_head = self.write_head + 1
end

function VariableTensor:shuffle(indices)
  indices = indices or torch.randperm(self:size()):long()
  self.indices[{{1, self:size()}}] = self.indices[{{1, self:size()}}]:index(1, indices)
  return indices
end

function VariableTensor:get(i)
  return self.store[{{self.indices[i][1], self.indices[i][2]}}]
end

function VariableTensor:batch(indices, b)
  if not self.max_len then
    local _
    self.max_len, _ = (self.indices[{{1, self:size()}, 2}] - self.indices[{{1, self:size()}, 1}] + 1):max(1)
    self.max_len = self.max_len[1]
  end

  b = b or torch.Tensor(indices:size(1), self.max_len):type(self.store:type())
  b:fill(1)
  local mask = b:clone():zero()

  for i = 1, indices:size(1) do
    local t = self:get(indices[i])
    b[{i, {1, t:size(1)}}]:copy(t)
    mask[{i, {1, t:size(1)}}] = 1
  end
  return b:narrow(1, 1, indices:size(1)), mask:narrow(1, 1, indices:size(1))
end

return VariableTensor

