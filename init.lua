require 'torch'

local torchlib = {}

torch.include('torchlib', 'util.lua')
torch.include('torchlib', 'list.lua')
torch.include('torchlib', 'map.lua')
torch.include('torchlib', 'queue.lua')
torch.include('torchlib', 'stack.lua')
torch.include('torchlib', 'heap.lua')
torch.include('torchlib', 'set.lua')
torch.include('torchlib', 'graph.lua')
torch.include('torchlib', 'tree.lua')
torch.include('torchlib', 'bst.lua')
torch.include('torchlib', 'vocab.lua')
torch.include('torchlib', 'variable_tensor.lua')

return torchlib
