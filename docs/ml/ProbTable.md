# ProbTable
Implementation of probability table using Torch tensor




## ProbTable:\_\_init(P, names)
[View source](http://github.com/vzhong/torchlib/blob/master/src//ml/ProbTable.lua#L17)

Constructor.

Arguments:

- `P ` (`torch.tensor`): probability Tensor, the `i`th dimension corresponds to the `i`th variable.
- `names ` (`table[string]`): A table of names for the variables. By default theses will be assigned using indices.

Example:. Optional.

```lua
local t = ProbTable(torch.Tensor{{0.2, 0.8}, {0.4, 0.6}, {0.1, 0.9}}, {'a', 'b'})
t:query{a=1, b=2}  0.8
t:query{a=2}  Tensor{0.4, 0.6}
```

## ProbTable:size()
[View source](http://github.com/vzhong/torchlib/blob/master/src//ml/ProbTable.lua#L35)



Returns:

- (`int`) number of variables in the table

## ProbTable:query(dict)
[View source](http://github.com/vzhong/torchlib/blob/master/src//ml/ProbTable.lua#L50)



Arguments:

- `dict ` (`table[string`): an assignment to consider

Example:. Optional, Default: `int]`.

Returns:

- (`torch.Tensor`) probabilities for the assignments in `dict`.

```lua
local t = ProbTable(torch.Tensor{{0.2, 0.8}, {0.4, 0.6}, {0.1, 0.9}}, {'a', 'b'})
t:query{a=1, b=2}
t:query{a=2}
```

The first query is `0.8`. The second query is `Tensor{0.4, 0.6}`

## ProbTable:clone()
[View source](http://github.com/vzhong/torchlib/blob/master/src//ml/ProbTable.lua#L63)



Returns:

- (`ProbTable`) a copy

## ProbTable:\_\_tostring\_\_()
[View source](http://github.com/vzhong/torchlib/blob/master/src//ml/ProbTable.lua#L70)



Returns:

- (`string`) string representation

## ProbTable:mul(B)
[View source](http://github.com/vzhong/torchlib/blob/master/src//ml/ProbTable.lua#L94)

Returns a new table that is the product of two tables.

Arguments:

- `B ` (`ProbTable`): another table.

Returns:

- (`ProbTable`) product of this and another table

## ProbTable:marginalize(name)
[View source](http://github.com/vzhong/torchlib/blob/master/src//ml/ProbTable.lua#L143)

Marginalizes this probability table in place.

Arguments:

- `name ` (`string`): the variable to marginalize.

Returns:

- (`ProbTable`) this probability table with the variable `name` marginalized out

## ProbTable:marginal(name)
[View source](http://github.com/vzhong/torchlib/blob/master/src//ml/ProbTable.lua#L160)

Marginalizes this probability table in place to calculate a marginal.

Arguments:

- `name ` (`string`): the variable to calculate.

Returns:

- (`ProbTable`) this probability table marginalizing all variables except `name`

## ProbTable:normalize()
[View source](http://github.com/vzhong/torchlib/blob/master/src//ml/ProbTable.lua#L175)

Normalizes this table by dividing by the sum of all probabilities.

Returns:

- (`ProbTable`) normalized table

