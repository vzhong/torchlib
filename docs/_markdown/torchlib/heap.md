<a name="torchlib.Heap.dok"></a>


## torchlib.Heap ##

 Implementation of max heap (eg. `parent >= child`). `Heap` is a subclass of `ArrayList`. 

<a class="entityLink" href="https://github.com/vzhong/torchlib/blob/975ba472d6e4fdaa1f6c82e04d3ff16b691aaa02/heap.lua#L5">[src]</a>
<a name="torchlib.Heap.parent"></a>


### torchlib.Heap.parent(i) ###

 Returns the parent index of `i`. 

<a class="entityLink" href="https://github.com/vzhong/torchlib/blob/975ba472d6e4fdaa1f6c82e04d3ff16b691aaa02/heap.lua#L10">[src]</a>
<a name="torchlib.Heap.left"></a>


### torchlib.Heap.left(i) ###

 Returns the left child index of `i`. 

<a class="entityLink" href="https://github.com/vzhong/torchlib/blob/975ba472d6e4fdaa1f6c82e04d3ff16b691aaa02/heap.lua#L15">[src]</a>
<a name="torchlib.Heap.right"></a>


### torchlib.Heap.right(i) ###

 Returns the right child index of `i`. 

<a class="entityLink" href="https://github.com/vzhong/torchlib/blob/975ba472d6e4fdaa1f6c82e04d3ff16b691aaa02/heap.lua#L23">[src]</a>
<a name="torchlib.Heap:maxHeapify"></a>


### torchlib.Heap:maxHeapify(i, effectiveSize) ###

 Recursively swaps down the node at `i` until the max heap condition is restored at `a[i]`.
Note: this function assumes that the binary trees rooted at left and right are max heaps but
`a[i]` may violate the max-heap condition


<a class="entityLink" href="https://github.com/vzhong/torchlib/blob/975ba472d6e4fdaa1f6c82e04d3ff16b691aaa02/heap.lua#L52">[src]</a>
<a name="torchlib.Heap:sort"></a>


### torchlib.Heap:sort() ###

 Sorts the heap using heap sort. 

<a class="entityLink" href="https://github.com/vzhong/torchlib/blob/975ba472d6e4fdaa1f6c82e04d3ff16b691aaa02/heap.lua#L62">[src]</a>
<a name="torchlib.Heap:push"></a>


### torchlib.Heap:push(key, val) ###

 Adds a `val` with priority `key` onto the heap while keeping max heap property. 

<a class="entityLink" href="https://github.com/vzhong/torchlib/blob/975ba472d6e4fdaa1f6c82e04d3ff16b691aaa02/heap.lua#L70">[src]</a>
<a name="torchlib.Heap:pop"></a>


### torchlib.Heap:pop() ###

 Removes and returns the max key item from the heap. 

<a class="entityLink" href="https://github.com/vzhong/torchlib/blob/975ba472d6e4fdaa1f6c82e04d3ff16b691aaa02/heap.lua#L81">[src]</a>
<a name="torchlib.Heap:peek"></a>


### torchlib.Heap:peek() ###

 Returns the max key item from the heap but does not remove it. 


#### Undocumented methods ####

<a name="torchlib.Heap:toString"></a>
 * `torchlib.Heap:toString()`
