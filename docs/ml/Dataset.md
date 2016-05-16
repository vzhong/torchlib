# Dataset
Implementation of dataset container.
The goal of this class is to provide utilities for manipulating generic datasets. in particular, a
dataset can be a list of examples, each with a fixed set of fields.




## Dataset:\_\_init(fields)
[View source](http://github.com/vzhong/torchlib/blob/master/src//ml/Dataset.lua#L30)

Constructor.

Arguments:

- `fields ` (`table[any:any]`): a table containing key value pairs

Each value is a list of tensors and `value[i]` contains the value corresponding to the `i`th example.

Example:.

Suppose we have two examples, with fields `X` and `Y`. The first example has `X=[1, 2, 3], Y=1` while

the second example has `X=[4, 5, 6, 7, 8}, Y=4`. To create a dataset:

```lua
X = {torch.Tensor{1, 2, 3}, torch.Tensor{4, 5, 6, 7, 8}}
Y = {1, 4}
d = Dataset{X = X, Y = Y}

Of course, in practice the fields can be arbitrary, so long as each field is a table and has an equal
number of elements.
```

## Dataset.from\_conll(fname)
[View source](http://github.com/vzhong/torchlib/blob/master/src//ml/Dataset.lua#L69)

Creates a dataset from CONLL format.

Arguments:

- `fname ` (`string`): path to CONLL file.

Returns:

- (`Dataset`) loaded dataset

The format is as follows:

```text
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

That is, the first line is a tab delimited header, followed by examples separated by a blank line.
The first line of the example is the class label. The rest of the rows correspond to tokens and their associated attributes.

Example:
```

```lua
dataset = Dataset.from_conll('data.conll')
```

## Dataset:\_\_tostring\_\_()
[View source](http://github.com/vzhong/torchlib/blob/master/src//ml/Dataset.lua#L112)



Returns:

- (`string`) string representation

## Dataset:size()
[View source](http://github.com/vzhong/torchlib/blob/master/src//ml/Dataset.lua#L126)



Returns:

- (`int`) number of examples in the dataset

## Dataset:kfolds(k)
[View source](http://github.com/vzhong/torchlib/blob/master/src//ml/Dataset.lua#L137)

Returns a table of `k` folds of the dataset.

Arguments:

- `k ` (`int`): how many folds to create.

Returns:

- (`table[table]`) tables of indices corresponding to each fold

Each fold consists of a random table of indices corresponding to the examples in the fold.

## Dataset:view(...)
[View source](http://github.com/vzhong/torchlib/blob/master/src//ml/Dataset.lua#L155)

Copies out a new Dataset which is a view into the current Dataset.

Arguments:

- `vararg ` (`vararg`): each argument is a tables of integer indices corresponding to a view.

Returns:

- (`vararg(Datasets)`) one dataset view for each list of indices

Example:

Suppose we already have a `dataset` and would like to split it into two datasets. We want
the first dataset `a` to contain examples 1 and 3 of the original dataset. We want the
second dataset `b` to contain examples 1, 2 and 3 (yes, duplicates are supported).

```lua
a, b = dataset:view({1, 3}, {1, 2, 3})
```

## Dataset:train\_dev\_split(train\_indices)
[View source](http://github.com/vzhong/torchlib/blob/master/src//ml/Dataset.lua#L181)

Creates a train split and a test split given the train indices.

Arguments:

- `train_indices ` (`table[int]`): a table of integers corresponding to indices of training examples.

Returns:

- (`Dataset, Dataset`) train and test dataset views

Other examples will be used as test examples.

Example:

Suppose we'd like to split a `dataset` and use its 1, 2, 4 and 5th examples for training.

```lua
train, test = dataset:train_dev_split{1, 2, 4, 5}
```

## Dataset:index(indices)
[View source](http://github.com/vzhong/torchlib/blob/master/src//ml/Dataset.lua#L198)

Reindexes the dataset accoring to the new indices.

Arguments:

- `indices ` (`table[int]`): indices to re-index the dataset with.

Returns:

- (`Dataset`) modified dataset

Example:

Suppose we have a `dataset` of 5 examples and want to swap example 1 with example 5.

```lua
dataset:index{5, 2, 3, 4, 1}
```

## Dataset:shuffle()
[View source](http://github.com/vzhong/torchlib/blob/master/src//ml/Dataset.lua#L211)

Shuffles the dataset in place

Returns:

- (`Dataset`) modified dataset

## Dataset:sort\_by\_length(field)
[View source](http://github.com/vzhong/torchlib/blob/master/src//ml/Dataset.lua#L221)

Sorts the examples in place by the length of the requested field.

Arguments:

- `field ` (`string`): field to sort with.

Returns:

- (`Dataset`) modified dataset

It is assumed that the field contains torch Tensors. Sorts in ascending order.

## Dataset.pad(tensors, PAD)
[View source](http://github.com/vzhong/torchlib/blob/master/src//ml/Dataset.lua#L244)

Prepends shorter tensors in a table of tensors with `PAD` such that each tensor in the batch are of the same length.

Arguments:

- `tensors ` (`table[torch.Tensor]`): tensors of varying lengths.
- `PAD ` (`int`): index to pad missing elements with.

Example:. Optional, Default: `0`.

```lua
X = {torch.Tensor{1, 2, 3}, torch.Tensor{4}}
Y = Dataset.pad(X, 0)

`Y` is now:
```

```lua
torch.Tensor{{1, 2, 3}, {0, 0, 4}}
```

## Dataset:batches(batch\_size)
[View source](http://github.com/vzhong/torchlib/blob/master/src//ml/Dataset.lua#L268)

Creates a batch iterator over the dataset.

Arguments:

- `batch_size ` (`int`): maximum size of each batch

Example:.

```lua
d = Dataset{X=X, Y=Y}
for batch, batch_end in d:batches(5) do
  print(batch.X)
  print(batch.Y)
end
```

## Dataset:transform(transforms, in\_place)
[View source](http://github.com/vzhong/torchlib/blob/master/src//ml/Dataset.lua#L306)

Applies transformations to fields in the dataset.

Arguments:

- `transforms ` (`table[string:function]`): a key-value map where a key is a field in the dataset and the corresponding value
is a function that is to be applied to the requested field for each example.
- `in_place ` (`boolean`): whether to apply the transformation in place or return a new dataset. Optional.

Example:

```lua
dataset = Dataset{names={'alice', 'bob', 'charlie'}, id={1, 2, 3}}
dataset2 = dataset:transform{names=string.upper, id=function(x) return x+1 end}
```

`dataset2` is now `Dataset{names={'ALICE', 'BOB', 'CHARLIE'}, id={2, 3, 4}}` while `dataset` remains unchanged.

```lua
dataset = Dataset{names={'alice', 'bob', 'charlie'}, id={1, 2, 3}}
dataset2 = dataset:transform({names=string.upper}, true)
```

`dataset` is now `Dataset{names={'ALICE', 'BOB', 'CHARLIE'}, id={1, 2, 3}}` and `dataset2` refers to `dataset`.

