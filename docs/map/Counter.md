# Counter
Implementation of a counter.




## Counter:\_\_init()
[View source](http://github.com/vzhong/torchlib/blob/master/src//map/Counter.lua#L8)

Constructor.


## Counter:add(key, count)
[View source](http://github.com/vzhong/torchlib/blob/master/src//map/Counter.lua#L16)

Increments the count for a key.

Arguments:

- `key ` (`any`): key to increment count for.
- `count ` (`int`): how much to increment count by.

Returns:

- (`int`) the new count

## Counter:get(key)
[View source](http://github.com/vzhong/torchlib/blob/master/src//map/Counter.lua#L27)



Arguments:

- `key ` (`any`): key to return count for.

Returns:

- (`int`) the count for the key

If `key` has not been added to the counter, then returns 0.

## Counter:reset()
[View source](http://github.com/vzhong/torchlib/blob/master/src//map/Counter.lua#L33)

Clears the counter.

Returns:

- (`Counter`) the modified counter

