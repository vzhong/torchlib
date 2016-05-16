## tl.range(from, to, inc)
[View source](http://github.com/vzhong/torchlib/blob/master/src//util/global.lua#L5)



Arguments:

- `from ` (`int`): start index.
- `end ` (`int`): end index. Optional, Default: `end`.
- `inc ` (`int`): value to increment by. Optional, Default: `1`.

Returns:

- (`table`) indices from `from` to `to`, incrementing by `inc`

## tl.equals(a, b)
[View source](http://github.com/vzhong/torchlib/blob/master/src//util/global.lua#L22)



Arguments:

- `a ` (`table`): first object.
- `b ` (`table`): second object.

Returns:

- (`boolean`) whether the two objects are equal to each other

## tl.deepcopy(t)
[View source](http://github.com/vzhong/torchlib/blob/master/src//util/global.lua#L34)



Arguments:

- `t ` (`any`): object to copy.

Returns:

- (`any`) deep copy

from https://gist.github.com/MihailJP/3931841

## tl.copy(t)
[View source](http://github.com/vzhong/torchlib/blob/master/src//util/global.lua#L51)



Arguments:

- `t ` (`any`): object to copy.

Returns:

- (`any`) shallow copy

