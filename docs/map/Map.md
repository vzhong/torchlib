# Map
Abstract map implementation.




## Map:\_\_init(key\_values)
[View source](http://github.com/vzhong/torchlib/blob/master/src//map/Map.lua#L9)

Constructor.

Arguments:

- `key_values ` (`table[any:any]`): used to initialize the map. Optional.


## Map:add(key, val)
[View source](http://github.com/vzhong/torchlib/blob/master/src//map/Map.lua#L16)

Adds an entry to the map.

Arguments:

- `key ` (`any`): key to add.
- `value ` (`any`): value to add.


## Map:addMany(tab)
[View source](http://github.com/vzhong/torchlib/blob/master/src//map/Map.lua#L22)

Adds many entries to the map.

Arguments:

- `tab ` (`table[any:any]`): a map of key value pairs to add. Optional.


## Map:copy()
[View source](http://github.com/vzhong/torchlib/blob/master/src//map/Map.lua#L27)



Returns:

- (`Map`) copy of this map

## Map:contains(key)
[View source](http://github.com/vzhong/torchlib/blob/master/src//map/Map.lua#L33)



Arguments:

- `key ` (`any`): key to check.

Returns:

- (`coolean`) whether the map contains the key

## Map:get(key, returnNilIfMissing)
[View source](http://github.com/vzhong/torchlib/blob/master/src//map/Map.lua#L44)

Retrieves the value for a key.

Arguments:

- `key ` (`any`): key to retrive.
- `returnNilIfMissing ` (`boolean`): whether to tolerate missing keys. Optional.

Returns:

- (`any`) value corresponding to the key

By default, asserts error if `key` is not found. If `returnNilIfMissing` is true,

then a `nil` will be returned if `key` is not found.

## Map:remove(key)
[View source](http://github.com/vzhong/torchlib/blob/master/src//map/Map.lua#L53)

Removes a key value pair

Arguments:

- `key ` (`any`): key to remove.

Returns:

- (`any`) the removed value

Asserts error if `key` is not in the map.

## Map:keys()
[View source](http://github.com/vzhong/torchlib/blob/master/src//map/Map.lua#L58)



Returns:

- (`table[any]`) a table of the keys in the map

## Map:totable()
[View source](http://github.com/vzhong/torchlib/blob/master/src//map/Map.lua#L63)



Returns:

- (`table[any:any]`) the map in table form

## Map:equals(another)
[View source](http://github.com/vzhong/torchlib/blob/master/src//map/Map.lua#L71)



Arguments:

- `another ` (`Map`): another map to compare to.

Returns:

- (`boolean`) whether this map equals `another`.

Maps are considered equal if all keys and corresponding values match.

## Map:size()
[View source](http://github.com/vzhong/torchlib/blob/master/src//map/Map.lua#L76)



Returns:

- (`int`) number of key value pairs in the map

