# VariableTensor
Implementation of a variable tensor class to efficiently store tensors of varying lengths.




## VariableTensor:\_\_init(opt)
[View source](http://github.com/vzhong/torchlib/blob/master/src//ml/VariableTensor.lua#L12)

Constructor.

Arguments:

- `preinit_size ` (`int`): how many indices to preallocate for. Optional, Default: `1`.
- `preinit_store_size ` (`int`): how many elements to preallocate for. Optional, Default: `1`.


## VariableTensor:cuda()
[View source](http://github.com/vzhong/torchlib/blob/master/src//ml/VariableTensor.lua#L30)

Moves the storage to cuda

Returns:

- (`VariableTensor`) modified tensor

## VariableTensor:size()
[View source](http://github.com/vzhong/torchlib/blob/master/src//ml/VariableTensor.lua#L36)



Returns:

- (`int`) sum of the size of each tensor in the storage

## VariableTensor:push(tensor)
[View source](http://github.com/vzhong/torchlib/blob/master/src//ml/VariableTensor.lua#L43)

Appends a tensor to the storage.

Arguments:

- `tensor ` (`torch.Tensor`): tensor to add to storage.

Returns:

- (`VariableTensor`) modified tensor

## VariableTensor:shuffle(indices)
[View source](http://github.com/vzhong/torchlib/blob/master/src//ml/VariableTensor.lua#L62)

Shuffles the indices.

Arguments:

- `indices ` (`torch.Tensor`): tensor that denotes how the new indices should be set. If not given, then a random
tensor will be generated. Optional.

Returns:

- (`torch.Tensor`) the `indices` tensor used to shuffle

## VariableTensor:get(i)
[View source](http://github.com/vzhong/torchlib/blob/master/src//ml/VariableTensor.lua#L71)

Retrieves the tensor at index `i`.

Arguments:

- `i ` (`int`): index to query.

Returns:

- (`torch.Tensor`) tensor at index

## VariableTensor:batch(indices, pad)
[View source](http://github.com/vzhong/torchlib/blob/master/src//ml/VariableTensor.lua#L78)

Creates a zero-padded batch from tensors at the indices `indices`.

Arguments:

- `indices ` (`table`): starting indices of tensors to pad.
- `pad ` (`int`): number to use to pad shorter tensors. Optional, Default: `0`.


