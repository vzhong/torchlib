# Heap
Max heap implementation.
This is a subclass of `List`.




## Heap.parent(i)
[View source](http://github.com/vzhong/torchlib/blob/master/src//list/Heap.lua#L10)



Arguments:

- `i ` (`int`): index to compute parent for.

Returns:

- (`int`) parent index of `i`

## Heap.left(i)
[View source](http://github.com/vzhong/torchlib/blob/master/src//list/Heap.lua#L16)



Arguments:

- `i ` (`int`): index to compute left child for.

Returns:

- (`int`) left child index of `i`

## Heap.right(i)
[View source](http://github.com/vzhong/torchlib/blob/master/src//list/Heap.lua#L22)



Arguments:

- `i ` (`int`): index to compute right child for.

Returns:

- (`int`) right child index of `i`

## Heap:maxHeapify(i, effectiveSize)
[View source](http://github.com/vzhong/torchlib/blob/master/src//list/Heap.lua#L35)

Restores max heap condition at the `i`th index.

Arguments:

- `i ` (`int`): index at which to restore max heap condition.
- `effectiveSize ` (`int`): effective size of the heap (eg. number of valid elements). Optional, Default: `size`.

Returns:

- (`Heap`) modified heap

Recursively swaps down the node at `i` until the max heap condition is restored at `a[i]`.

Note: this function assumes that the binary trees rooted at left and right are max heaps but

`a[i]` may violate the max-heap condition.

## Heap:sort()
[View source](http://github.com/vzhong/torchlib/blob/master/src//list/Heap.lua#L65)

Sorts the heap using heap sort.

Returns:

- (`Heap`) sorted heap

## Heap:push(key, val)
[View source](http://github.com/vzhong/torchlib/blob/master/src//list/Heap.lua#L79)

Adds an element to the heap while keeping max heap property.

Arguments:

- `key ` (`number`): priority to add with.
- `val ` (`any`): element to add to heap.

Returns:

- (`Heap`) modified heap

## Heap:pop()
[View source](http://github.com/vzhong/torchlib/blob/master/src//list/Heap.lua#L88)

Removes and returns the max priority element from the heap.

Returns:

- (`any`) removed element

## Heap:peek()
[View source](http://github.com/vzhong/torchlib/blob/master/src//list/Heap.lua#L101)



{any} max priority element from the heap

Note: the element is not removed.

