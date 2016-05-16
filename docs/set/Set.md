# Set
Implementation of set.




## Set:\_\_init(values)
[View source](http://github.com/vzhong/torchlib/blob/master/src//set/Set.lua#L9)

Constructor.

Arguments:

- `values ` (`table[any]`): used to initialize the set. Optional.


## Set.keyOf(val)
[View source](http://github.com/vzhong/torchlib/blob/master/src//set/Set.lua#L18)



Arguments:

- `val ` (`any`): value to produce a key for.

Returns:

- (`torch.pointer`) unique key for the value

## Set:size()
[View source](http://github.com/vzhong/torchlib/blob/master/src//set/Set.lua#L27)



Returns:

- (`int`) number of values in the set

## Set:add(val)
[View source](http://github.com/vzhong/torchlib/blob/master/src//set/Set.lua#L34)

Adds a value to the set.

Arguments:

- `val ` (`any`): value to add to the set.

Returns:

- (`Set`) modified set

## Set:addMany(...)
[View source](http://github.com/vzhong/torchlib/blob/master/src//set/Set.lua#L46)

Adds a variable number of values to the set.

Arguments:

- `vararg ` (`vararg`): values to add to the set.

Returns:

- (`Set`) modified set

## Set:copy()
[View source](http://github.com/vzhong/torchlib/blob/master/src//set/Set.lua#L55)



Returns:

- (`Set`) copy of the set

## Set:contains(val)
[View source](http://github.com/vzhong/torchlib/blob/master/src//set/Set.lua#L61)



Arguments:

- `val ` (`any`): value to check for.

Returns:

- (`boolean`) whether the set contains `val`

## Set:remove(val)
[View source](http://github.com/vzhong/torchlib/blob/master/src//set/Set.lua#L69)



Arguments:

- `val ` (`any`): value to remove from the set.

Returns:

- (`Set`) modified set
If `val` is not found then an error is raised.

## Set:totable()
[View source](http://github.com/vzhong/torchlib/blob/master/src//set/Set.lua#L78)



Returns:

- (`tabl`) the set in table format

## Set:equals(another)
[View source](http://github.com/vzhong/torchlib/blob/master/src//set/Set.lua#L89)

Compares two sets.

Arguments:

- `another ` (`Set`): another set.

Returns:

- (`boolean`) whether this set and `another` contain the same values

## Set:union(another)
[View source](http://github.com/vzhong/torchlib/blob/master/src//set/Set.lua#L105)

Computes the union of two sets.

Arguments:

- `another ` (`Set`): another set.

Returns:

- (`Set`) a set of values that are in this set or in `another`

## Set:intersect(another)
[View source](http://github.com/vzhong/torchlib/blob/master/src//set/Set.lua#L116)

Computes the intersection of two sets.

Arguments:

- `another ` (`Set`): another set.

Returns:

- (`Set`) a set of values that are in this set and in `another`

## Set:subtract(another)
[View source](http://github.com/vzhong/torchlib/blob/master/src//set/Set.lua#L129)

Subtracts another set from this one.

Arguments:

- `another ` (`Set`): another set.

Returns:

- (`Set`) a set of values that are in this set but not in `another`

## Set:\_\_tostring\_\_()
[View source](http://github.com/vzhong/torchlib/blob/master/src//set/Set.lua#L140)



Returns:

- (`string`) string representation

