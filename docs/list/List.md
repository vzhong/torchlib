# List
Abstract list implementation.




## List:\_\_init(values)
[View source](http://github.com/vzhong/torchlib/blob/master/src//list/List.lua#L9)

Constructor.

Arguments:

- `values ` (`table[any]`): used to initialize the list. Optional.


## List:add(val, index)
[View source](http://github.com/vzhong/torchlib/blob/master/src//list/List.lua#L17)

Adds element to list.

Arguments:

- `val ` (`any`): value to add.
- `index ` (`int`): index to add value at. Optional, Default: `end`.

Returns:

- (`List`) - modified list

## List:get(index)
[View source](http://github.com/vzhong/torchlib/blob/master/src//list/List.lua#L25)



Arguments:

- `index ` (`int`): index to retrieve value for.

Returns:

- (`any`) - value at index

Asserts error if `index` is out of bounds.

## List:set(index, val)
[View source](http://github.com/vzhong/torchlib/blob/master/src//list/List.lua#L35)

Sets the value at index.

Arguments:

- `index ` (`int`): inde to set value for.
- `val ` (`any`): value to set.

Returns:

- (`List`) - modified list

Asserts error if `index` is out of bounds.

## List:remove(index)
[View source](http://github.com/vzhong/torchlib/blob/master/src//list/List.lua#L44)



Arguments:

- `index ` (`int`): index to remove at.

Returns:

- (`any`) - value at index

Elements after `index` will be shifted to the left by 1.

Asserts error if `index` is out of bounds.

## List:equals(another)
[View source](http://github.com/vzhong/torchlib/blob/master/src//list/List.lua#L53)

Compares two lists.

Arguments:

- `another ` (`List`): another list to compare to.

Returns:

- (`boolean`) whether this list is equal to `another`

Lists are considered equal if their values match at every position.

## List:swap(i, j)
[View source](http://github.com/vzhong/torchlib/blob/master/src//list/List.lua#L61)

Swaps value at two indices.

Arguments:

- `i ` (`int`): first index.
- `j ` (`int`): second index.

Returns:

- (`List`) - modified list

## List:totable()
[View source](http://github.com/vzhong/torchlib/blob/master/src//list/List.lua#L67)

Returns the list in table form.

Returns:

- (`table[any]`) a table containing the values in the list.

## List:assertValidIndex(index)
[View source](http://github.com/vzhong/torchlib/blob/master/src//list/List.lua#L73)

Asserts that index is inside the list.

Arguments:

- `index ` (`int`): index to check.


## List:size()
[View source](http://github.com/vzhong/torchlib/blob/master/src//list/List.lua#L78)



Returns:

- (`int`) size of the list

## List:addMany(...)
[View source](http://github.com/vzhong/torchlib/blob/master/src//list/List.lua#L85)

Adds items to the list.

Arguments:

- `vararg ` (`vararg[any]`): values to add to the list.

Returns:

- (`List`) modified list

## List:contains(val)
[View source](http://github.com/vzhong/torchlib/blob/master/src//list/List.lua#L96)

Returns whether the list contains a value.

Arguments:

- `val ` (`any`): value to check.

Returns:

- (`boolean`) whether `val` is in the list

## List:copy()
[View source](http://github.com/vzhong/torchlib/blob/master/src//list/List.lua#L106)



Returns:

- (`List`) a copy of this list

## List:isEmpty()
[View source](http://github.com/vzhong/torchlib/blob/master/src//list/List.lua#L111)



Returns:

- (`boolean`) whether the list is empty

## List:sublist(start, finish)
[View source](http://github.com/vzhong/torchlib/blob/master/src//list/List.lua#L119)

Returns a copy of a segment of this list.

Arguments:

- `start ` (`int`): start of the segment.
- `finish ` (`int`): start of the segment. Optional, Default: `end`.


## List:sort(start, finish)
[View source](http://github.com/vzhong/torchlib/blob/master/src//list/List.lua#L131)

Sorts the list in place.

Arguments:

- `start ` (`int`): start index of the sort. Optional, Default: `1`.
- `finish ` (`int`): end index of the sort. Optional, Default: `end`.


## List:\_\_tostring\_\_()
[View source](http://github.com/vzhong/torchlib/blob/master/src//list/List.lua#L156)



Returns:

- (`string`) string representation

