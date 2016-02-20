<a name="torchlib.Set.dok"></a>


## torchlib.Set ##

 Implementation of set. 

<a class="entityLink" href="https://github.com/vzhong/torchlib/blob/975ba472d6e4fdaa1f6c82e04d3ff16b691aaa02/set.lua#L5">[src]</a>
<a name="torchlib.Set"></a>


### torchlib.Set(values) ###

 Constructor. `values` is an optional table of values that is used to initialize the set. 

<a class="entityLink" href="https://github.com/vzhong/torchlib/blob/975ba472d6e4fdaa1f6c82e04d3ff16b691aaa02/set.lua#L13">[src]</a>
<a name="torchlib.Set.keyOf"></a>


### torchlib.Set.keyOf(val) ###

 Returns a unique key for a value. 

<a class="entityLink" href="https://github.com/vzhong/torchlib/blob/975ba472d6e4fdaa1f6c82e04d3ff16b691aaa02/set.lua#L22">[src]</a>
<a name="torchlib.Set:size"></a>


### torchlib.Set:size() ###

 Returns the number of values in the set. 

<a class="entityLink" href="https://github.com/vzhong/torchlib/blob/975ba472d6e4fdaa1f6c82e04d3ff16b691aaa02/set.lua#L27">[src]</a>
<a name="torchlib.Set:add"></a>


### torchlib.Set:add(val) ###

 Adds a value to the set. 

<a class="entityLink" href="https://github.com/vzhong/torchlib/blob/975ba472d6e4fdaa1f6c82e04d3ff16b691aaa02/set.lua#L37">[src]</a>
<a name="torchlib.Set:addMany"></a>


### torchlib.Set:addMany(...) ###

 Adds a variable number of values to the set. 

<a class="entityLink" href="https://github.com/vzhong/torchlib/blob/975ba472d6e4fdaa1f6c82e04d3ff16b691aaa02/set.lua#L46">[src]</a>
<a name="torchlib.Set:copy"></a>


### torchlib.Set:copy() ###

 Returns a copy of the set. 

<a class="entityLink" href="https://github.com/vzhong/torchlib/blob/975ba472d6e4fdaa1f6c82e04d3ff16b691aaa02/set.lua#L51">[src]</a>
<a name="torchlib.Set:contains"></a>


### torchlib.Set:contains(val) ###

 Returns whether the set contains `val`. 

<a class="entityLink" href="https://github.com/vzhong/torchlib/blob/975ba472d6e4fdaa1f6c82e04d3ff16b691aaa02/set.lua#L57">[src]</a>
<a name="torchlib.Set:remove"></a>


### torchlib.Set:remove(val) ###

 Removes `val` from the set. If `val` is not found then an error is raised. 

<a class="entityLink" href="https://github.com/vzhong/torchlib/blob/975ba472d6e4fdaa1f6c82e04d3ff16b691aaa02/set.lua#L67">[src]</a>
<a name="torchlib.Set:toTable"></a>


### torchlib.Set:toTable() ###

 Returns the set in table format. 

<a class="entityLink" href="https://github.com/vzhong/torchlib/blob/975ba472d6e4fdaa1f6c82e04d3ff16b691aaa02/set.lua#L76">[src]</a>
<a name="torchlib.Set:equals"></a>


### torchlib.Set:equals(another) ###

 Returns whether the set is equal to `another`. Sets are considered equal if the values contained are identical. 

<a class="entityLink" href="https://github.com/vzhong/torchlib/blob/975ba472d6e4fdaa1f6c82e04d3ff16b691aaa02/set.lua#L90">[src]</a>
<a name="torchlib.Set:union"></a>


### torchlib.Set:union(another) ###

 Returns the union of this set and `another`. 

<a class="entityLink" href="https://github.com/vzhong/torchlib/blob/975ba472d6e4fdaa1f6c82e04d3ff16b691aaa02/set.lua#L99">[src]</a>
<a name="torchlib.Set:intersect"></a>


### torchlib.Set:intersect(another) ###

 Returns the intersection of this set and `another`. 

<a class="entityLink" href="https://github.com/vzhong/torchlib/blob/975ba472d6e4fdaa1f6c82e04d3ff16b691aaa02/set.lua#L110">[src]</a>
<a name="torchlib.Set:subtract"></a>


### torchlib.Set:subtract(another) ###

 Returns a set of values that are in this set but not in `another`. 


#### Undocumented methods ####

<a name="torchlib.Set:toString"></a>
 * `torchlib.Set:toString()`
