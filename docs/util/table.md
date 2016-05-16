## table.tostring(t, indent, s)
[View source](http://github.com/vzhong/torchlib/blob/master/src//util/table.lua#L5)



Arguments:

- `t ` (`table`): a table.
- `indent ` (`string`): indentation for nested keys. Optional.
- `s ` (`string`): accumulated string. Optional.

Returns:

- (`string`) string representation for the table

## table.shuffle(t)
[View source](http://github.com/vzhong/torchlib/blob/master/src//util/table.lua#L22)



Arguments:

- `t ` (`table`): table to shuffle in place.

Returns:

- (`table`) shuffled table

## table.equals(t1, t2)
[View source](http://github.com/vzhong/torchlib/blob/master/src//util/table.lua#L35)



Arguments:

- `t1 ` (`table[any]`): first table.
- `t2 ` (`table[any]`): seoncd table.

Returns:

- (`boolean`) whether the keys and values of each table are equal

## table.valuesEqual(t1, t2)
[View source](http://github.com/vzhong/torchlib/blob/master/src//util/table.lua#L52)



Arguments:

- `t1 ` (`table[any]`): first table.
- `t2 ` (`table[any]`): seoncd table.

Returns:

- (`boolean`) whether the values of each table are equal, disregarding order

## table.reverse(t)
[View source](http://github.com/vzhong/torchlib/blob/master/src//util/table.lua#L68)



Arguments:

- `t ` (`table`): table to reverse.

Returns:

- (`table`) A copy of the table, reversed.

## table.contains(t, val)
[View source](http://github.com/vzhong/torchlib/blob/master/src//util/table.lua#L79)



Arguments:

- `t ` (`table`): table to check.
- `val ` (`any`): value to check.

Returns:

- (`boolean`) whether the tabale contains the value

## table.flatten(t, tab, prefix)
[View source](http://github.com/vzhong/torchlib/blob/master/src//util/table.lua#L93)

Flattens the table.

Arguments:

- `t ` (`table`): the table to modify.
- `tab ` (`table`): where to store the results. If not given, then a new table will be used. Optional.
- `prefix ` (`string`): string to use to join nested keys. Optional, Default: `'__'`.

Returns:

- (`table`) flattened table

## table.map(t, callback)
[View source](http://github.com/vzhong/torchlib/blob/master/src//util/table.lua#L110)

Applies `callback` to each element in `t` and returns the results in another table.

Arguments:

- `t ` (`table`): the table to modify.
- `callback ` (`function`): function to apply.

Returns:

- (`table`) modified table

## table.select(t, keys, forget\_keys)
[View source](http://github.com/vzhong/torchlib/blob/master/src//util/table.lua#L125)

Selects items from table `t`.

Arguments:

- `t ` (`table`): table to select from.
- `keys ` (`table`): table of keys.
- `forget_keys ` (`boolean`): whether to retain the keys. Optional.

Returns:

- (`table`) a table of key value pairs where the keys are `keys` and the values are corresponding values from `t`.

If `forget_keys` is `true`, then the returned table will have integer keys.

## table.extend(t, another)
[View source](http://github.com/vzhong/torchlib/blob/master/src//util/table.lua#L141)

Extends the table `t` with another table `another`

Arguments:

- `t ` (`table`): first table.
- `another ` (`table`): second table.

Returns:

- (`table`) modified first table

## table.combinations(input)
[View source](http://github.com/vzhong/torchlib/blob/master/src//util/table.lua#L159)

Returns all combinations of elements in a table.

Arguments:

- `input ` (`table[table[any]]`): a collection of lists to compute the combination for.

Returns:

- (`table[table[any]]`) combinations of the input

Example:

```lua
table.combinations{{1, 2}, {'a', 'b', 'c'}}

This returns `{{1, 'a'}, {1, 'b'}, {1, 'c'}, {2, 'a'}, {2, 'b'}, {2, 'c'}}`
```

