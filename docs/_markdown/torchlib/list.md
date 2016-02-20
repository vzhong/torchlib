<a name="torchlib.List.dok"></a>


## torchlib.List ##

 Abstract list. 
<a name="torchlib.ArrayList.dok"></a>


## torchlib.ArrayList ##

 Array implementation of list. 
<a name="torchlib.LinkedList.dok"></a>


## torchlib.LinkedList ##

 Linked list implementation of list. 

<a class="entityLink" href="https://github.com/vzhong/torchlib/blob/975ba472d6e4fdaa1f6c82e04d3ff16b691aaa02/list.lua#L5">[src]</a>
<a name="torchlib.List"></a>


### torchlib.List(values) ###

 Constructor. `values` is an optional table used to initialize the list. 

<a class="entityLink" href="https://github.com/vzhong/torchlib/blob/975ba472d6e4fdaa1f6c82e04d3ff16b691aaa02/list.lua#L10">[src]</a>
<a name="torchlib.List:add"></a>


### torchlib.List:add(val, index) ###

 Adds `val` to list at index `index`. By defalut `index` defaults to the last element. 

<a class="entityLink" href="https://github.com/vzhong/torchlib/blob/975ba472d6e4fdaa1f6c82e04d3ff16b691aaa02/list.lua#L15">[src]</a>
<a name="torchlib.List:get"></a>


### torchlib.List:get(index) ###

 Returns the value at index `index`. Asserts error if `index` is out of bounds. 

<a class="entityLink" href="https://github.com/vzhong/torchlib/blob/975ba472d6e4fdaa1f6c82e04d3ff16b691aaa02/list.lua#L20">[src]</a>
<a name="torchlib.List:set"></a>


### torchlib.List:set(index, val) ###

 Sets the value at index `index` to `val`. Asserts error if `index` is out of bounds. 

<a class="entityLink" href="https://github.com/vzhong/torchlib/blob/975ba472d6e4fdaa1f6c82e04d3ff16b691aaa02/list.lua#L25">[src]</a>
<a name="torchlib.List:remove"></a>


### torchlib.List:remove(index) ###

 Removes the value at index `index`. Elements after `index` will be shifted to the left by 1. Asserts error if `index` is out of bounds. 

<a class="entityLink" href="https://github.com/vzhong/torchlib/blob/975ba472d6e4fdaa1f6c82e04d3ff16b691aaa02/list.lua#L30">[src]</a>
<a name="torchlib.List:equals"></a>


### torchlib.List:equals(another) ###

 Returns whether this list is equal to `another`. Lists are considered equal if their values match at every position. 

<a class="entityLink" href="https://github.com/vzhong/torchlib/blob/975ba472d6e4fdaa1f6c82e04d3ff16b691aaa02/list.lua#L35">[src]</a>
<a name="torchlib.List:swap"></a>


### torchlib.List:swap(i, j) ###

 Swaps the value at `i` with the value at `j`. 

<a class="entityLink" href="https://github.com/vzhong/torchlib/blob/975ba472d6e4fdaa1f6c82e04d3ff16b691aaa02/list.lua#L40">[src]</a>
<a name="torchlib.List:toTable"></a>


### torchlib.List:toTable() ###

 Returns the list in table form. 

<a class="entityLink" href="https://github.com/vzhong/torchlib/blob/975ba472d6e4fdaa1f6c82e04d3ff16b691aaa02/list.lua#L45">[src]</a>
<a name="torchlib.List:assertValidIndex"></a>


### torchlib.List:assertValidIndex(index) ###

 Asserts that `index` is inside the list. 

<a class="entityLink" href="https://github.com/vzhong/torchlib/blob/975ba472d6e4fdaa1f6c82e04d3ff16b691aaa02/list.lua#L50">[src]</a>
<a name="torchlib.List:size"></a>


### torchlib.List:size() ###

 Returns the size of the list. 

<a class="entityLink" href="https://github.com/vzhong/torchlib/blob/975ba472d6e4fdaa1f6c82e04d3ff16b691aaa02/list.lua#L55">[src]</a>
<a name="torchlib.List:addMany"></a>


### torchlib.List:addMany(...) ###

 Adds a variable number of items to the list. 

<a class="entityLink" href="https://github.com/vzhong/torchlib/blob/975ba472d6e4fdaa1f6c82e04d3ff16b691aaa02/list.lua#L64">[src]</a>
<a name="torchlib.List:contains"></a>


### torchlib.List:contains(val) ###

 Returns whether `val` is in the list. 

<a class="entityLink" href="https://github.com/vzhong/torchlib/blob/975ba472d6e4fdaa1f6c82e04d3ff16b691aaa02/list.lua#L74">[src]</a>
<a name="torchlib.List:copy"></a>


### torchlib.List:copy() ###

 Returns a copy of this list. 

<a class="entityLink" href="https://github.com/vzhong/torchlib/blob/975ba472d6e4fdaa1f6c82e04d3ff16b691aaa02/list.lua#L79">[src]</a>
<a name="torchlib.List:isEmpty"></a>


### torchlib.List:isEmpty() ###

 Returns whether the list is empty. 

<a class="entityLink" href="https://github.com/vzhong/torchlib/blob/975ba472d6e4fdaa1f6c82e04d3ff16b691aaa02/list.lua#L89">[src]</a>
<a name="torchlib.List:sublist"></a>


### torchlib.List:sublist(start, finish) ###

 Returns a new list containing a consecutive run from this list.

Parameters:
- `start`: the start of the run
- `finish` (optional): the end of the run, defaults to the end of the list


<a class="entityLink" href="https://github.com/vzhong/torchlib/blob/975ba472d6e4fdaa1f6c82e04d3ff16b691aaa02/list.lua#L103">[src]</a>
<a name="torchlib.List:sort"></a>


### torchlib.List:sort(start, finish) ###

 Sorts the list in place.
  Parameters:
  - `start` (optional): the start of the sort, defaults to 1
  - `finish` (optional): the end of the sort, defaults to the end of the list


<a class="entityLink" href="https://github.com/vzhong/torchlib/blob/975ba472d6e4fdaa1f6c82e04d3ff16b691aaa02/list.lua#L238">[src]</a>
<a name="torchlib.LinkedList:head"></a>


### torchlib.LinkedList:head() ###

 Returns the head of the linked list. 


#### Undocumented methods ####

<a name="torchlib.List:toString"></a>
 * `torchlib.List:toString()`
<a name="torchlib.ArrayList"></a>
 * `torchlib.ArrayList(values)`
<a name="torchlib.ArrayList:add"></a>
 * `torchlib.ArrayList:add(val, index)`
<a name="torchlib.ArrayList:get"></a>
 * `torchlib.ArrayList:get(index)`
<a name="torchlib.ArrayList:set"></a>
 * `torchlib.ArrayList:set(index, val)`
<a name="torchlib.ArrayList:remove"></a>
 * `torchlib.ArrayList:remove(index)`
<a name="torchlib.ArrayList:equals"></a>
 * `torchlib.ArrayList:equals(another)`
<a name="torchlib.ArrayList:swap"></a>
 * `torchlib.ArrayList:swap(i, j)`
<a name="torchlib.ArrayList:toTable"></a>
 * `torchlib.ArrayList:toTable()`
<a name="torchlib.LinkedList.Node"></a>
 * `torchlib.LinkedList.Node(val)`
<a name="torchlib.LinkedList.Node:toString"></a>
 * `torchlib.LinkedList.Node:toString()`
<a name="torchlib.LinkedList"></a>
 * `torchlib.LinkedList(values)`
<a name="torchlib.LinkedList:size"></a>
 * `torchlib.LinkedList:size()`
<a name="torchlib.LinkedList:add"></a>
 * `torchlib.LinkedList:add(val, index)`
<a name="torchlib.LinkedList:get"></a>
 * `torchlib.LinkedList:get(index)`
<a name="torchlib.LinkedList:set"></a>
 * `torchlib.LinkedList:set(index, val)`
<a name="torchlib.LinkedList:remove"></a>
 * `torchlib.LinkedList:remove(index)`
<a name="torchlib.LinkedList:swap"></a>
 * `torchlib.LinkedList:swap(i, j)`
<a name="torchlib.LinkedList:equals"></a>
 * `torchlib.LinkedList:equals(another)`
<a name="torchlib.LinkedList:toTable"></a>
 * `torchlib.LinkedList:toTable()`
