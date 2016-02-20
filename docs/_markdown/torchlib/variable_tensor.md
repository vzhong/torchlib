<a name="torchlib.VariableTensor.dok"></a>


## torchlib.VariableTensor ##

 Implementation of a variable tensor class to efficiently store tensors of varying lengths. 

<a class="entityLink" href="https://github.com/vzhong/torchlib/blob/975ba472d6e4fdaa1f6c82e04d3ff16b691aaa02/variable_tensor.lua#L11">[src]</a>
<a name="torchlib.VariableTensor"></a>


### torchlib.VariableTensor(opt) ###

 Constructor.
  Options:
  - `preinit_size`: how many indices to preallocate for, defaults to 1
  - `preinit_store_size`: how many elements to preallocate for, defaults to 1


<a class="entityLink" href="https://github.com/vzhong/torchlib/blob/975ba472d6e4fdaa1f6c82e04d3ff16b691aaa02/variable_tensor.lua#L28">[src]</a>
<a name="torchlib.VariableTensor:cuda"></a>


### torchlib.VariableTensor:cuda() ###

 Moves the storage to cuda. 

<a class="entityLink" href="https://github.com/vzhong/torchlib/blob/975ba472d6e4fdaa1f6c82e04d3ff16b691aaa02/variable_tensor.lua#L33">[src]</a>
<a name="torchlib.VariableTensor:size"></a>


### torchlib.VariableTensor:size() ###

 Returns the sum of the size of each tensor in the storage. 

<a class="entityLink" href="https://github.com/vzhong/torchlib/blob/975ba472d6e4fdaa1f6c82e04d3ff16b691aaa02/variable_tensor.lua#L38">[src]</a>
<a name="torchlib.VariableTensor:push"></a>


### torchlib.VariableTensor:push(tensor) ###

 Appends a tensor to the storage. 

<a class="entityLink" href="https://github.com/vzhong/torchlib/blob/975ba472d6e4fdaa1f6c82e04d3ff16b691aaa02/variable_tensor.lua#L53">[src]</a>
<a name="torchlib.VariableTensor:shuffle"></a>


### torchlib.VariableTensor:shuffle(indices) ###

 Shuffles the indices. `indices` is an optional tensor that denotes how the new indices should be set. 

<a class="entityLink" href="https://github.com/vzhong/torchlib/blob/975ba472d6e4fdaa1f6c82e04d3ff16b691aaa02/variable_tensor.lua#L60">[src]</a>
<a name="torchlib.VariableTensor:get"></a>


### torchlib.VariableTensor:get(i) ###

 Retrieves the tensor at index `i`. 

<a class="entityLink" href="https://github.com/vzhong/torchlib/blob/975ba472d6e4fdaa1f6c82e04d3ff16b691aaa02/variable_tensor.lua#L65">[src]</a>
<a name="torchlib.VariableTensor:batch"></a>


### torchlib.VariableTensor:batch(indices, b) ###

 Creates a zero-padded batch from tensors at the indices `indices`. `b` is an optional batch tensor that, if given, will be filled with the requested tensors. 
