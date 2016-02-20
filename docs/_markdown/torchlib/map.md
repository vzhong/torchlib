<a name="torchlib.Map.dok"></a>


## torchlib.Map ##

 Abstract map. 
<a name="torchlib.HashMap.dok"></a>


## torchlib.HashMap ##

 Implementation of hash map. 

<a class="entityLink" href="https://github.com/vzhong/torchlib/blob/975ba472d6e4fdaa1f6c82e04d3ff16b691aaa02/map.lua#L5">[src]</a>
<a name="torchlib.Map"></a>


### torchlib.Map(key_values) ###

 Constructor. `key_values` is an optional table that is used to initialize the map. 

<a class="entityLink" href="https://github.com/vzhong/torchlib/blob/975ba472d6e4fdaa1f6c82e04d3ff16b691aaa02/map.lua#L10">[src]</a>
<a name="torchlib.Map:add"></a>


### torchlib.Map:add(key, val) ###

 Adds a key value pair to the map. 

<a class="entityLink" href="https://github.com/vzhong/torchlib/blob/975ba472d6e4fdaa1f6c82e04d3ff16b691aaa02/map.lua#L15">[src]</a>
<a name="torchlib.Map:addMany"></a>


### torchlib.Map:addMany(tab) ###

 Adds many key value pairs, in the form of a table, to the map. 

<a class="entityLink" href="https://github.com/vzhong/torchlib/blob/975ba472d6e4fdaa1f6c82e04d3ff16b691aaa02/map.lua#L20">[src]</a>
<a name="torchlib.Map:copy"></a>


### torchlib.Map:copy() ###

 Returns a copy of this map. 

<a class="entityLink" href="https://github.com/vzhong/torchlib/blob/975ba472d6e4fdaa1f6c82e04d3ff16b691aaa02/map.lua#L25">[src]</a>
<a name="torchlib.Map:contains"></a>


### torchlib.Map:contains(key) ###

 Returns whether the map contains the key `key`. 

<a class="entityLink" href="https://github.com/vzhong/torchlib/blob/975ba472d6e4fdaa1f6c82e04d3ff16b691aaa02/map.lua#L31">[src]</a>
<a name="torchlib.Map:get"></a>


### torchlib.Map:get(key, returnNilIfMissing) ###

 Retrieves the value with key `key`. By default, asserts error if `key` is not found.
  if `returnNilIfMissing` is true, the a `nil` will be returned if `key` is not found. 

<a class="entityLink" href="https://github.com/vzhong/torchlib/blob/975ba472d6e4fdaa1f6c82e04d3ff16b691aaa02/map.lua#L36">[src]</a>
<a name="torchlib.Map:remove"></a>


### torchlib.Map:remove(key) ###

 Removes the key value pair with key `key`. Asserts error if `key` is not in the map. 

<a class="entityLink" href="https://github.com/vzhong/torchlib/blob/975ba472d6e4fdaa1f6c82e04d3ff16b691aaa02/map.lua#L41">[src]</a>
<a name="torchlib.Map:keySet"></a>


### torchlib.Map:keySet() ###

 Returns a table of the keys in the map. 

<a class="entityLink" href="https://github.com/vzhong/torchlib/blob/975ba472d6e4fdaa1f6c82e04d3ff16b691aaa02/map.lua#L46">[src]</a>
<a name="torchlib.Map:toTable"></a>


### torchlib.Map:toTable() ###

 Returns the map in table form. 

<a class="entityLink" href="https://github.com/vzhong/torchlib/blob/975ba472d6e4fdaa1f6c82e04d3ff16b691aaa02/map.lua#L55">[src]</a>
<a name="torchlib.Map:equals"></a>


### torchlib.Map:equals(another) ###

 Returns whether this map equals `another`. Maps are considered equal if all keys and corresponding values match. 

<a class="entityLink" href="https://github.com/vzhong/torchlib/blob/975ba472d6e4fdaa1f6c82e04d3ff16b691aaa02/map.lua#L60">[src]</a>
<a name="torchlib.Map:size"></a>


### torchlib.Map:size() ###

 Returns the number of key value pairs in the map. 


#### Undocumented methods ####

<a name="torchlib.Map:toString"></a>
 * `torchlib.Map:toString()`
<a name="torchlib.HashMap"></a>
 * `torchlib.HashMap(key_values)`
<a name="torchlib.HashMap:add"></a>
 * `torchlib.HashMap:add(key, val)`
<a name="torchlib.HashMap:addMany"></a>
 * `torchlib.HashMap:addMany(tab)`
<a name="torchlib.HashMap:copy"></a>
 * `torchlib.HashMap:copy()`
<a name="torchlib.HashMap:contains"></a>
 * `torchlib.HashMap:contains(key)`
<a name="torchlib.HashMap:get"></a>
 * `torchlib.HashMap:get(key, returnNilIfMissing)`
<a name="torchlib.HashMap:remove"></a>
 * `torchlib.HashMap:remove(key)`
<a name="torchlib.HashMap:keySet"></a>
 * `torchlib.HashMap:keySet()`
<a name="torchlib.HashMap:toTable"></a>
 * `torchlib.HashMap:toTable()`
<a name="torchlib.HashMap:toString"></a>
 * `torchlib.HashMap:toString()`
<a name="torchlib.HashMap:equals"></a>
 * `torchlib.HashMap:equals(another)`
