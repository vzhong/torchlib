<a name="torchlib.Vocab.dok"></a>


## torchlib.Vocab ##

 Implementation of a vocabulary class 

<a class="entityLink" href="https://github.com/vzhong/torchlib/blob/975ba472d6e4fdaa1f6c82e04d3ff16b691aaa02/vocab.lua#L8">[src]</a>
<a name="torchlib.Vocab"></a>


### torchlib.Vocab(unk) ###

 Constructor.
  Parameters:
  - `unk`: the symbol for the unknown token.


<a class="entityLink" href="https://github.com/vzhong/torchlib/blob/975ba472d6e4fdaa1f6c82e04d3ff16b691aaa02/vocab.lua#L21">[src]</a>
<a name="torchlib.Vocab:contains"></a>


### torchlib.Vocab:contains(word) ###

 Returns whether `word` is in the vocabulary. 

<a class="entityLink" href="https://github.com/vzhong/torchlib/blob/975ba472d6e4fdaa1f6c82e04d3ff16b691aaa02/vocab.lua#L26">[src]</a>
<a name="torchlib.Vocab:count"></a>


### torchlib.Vocab:count(word) ###

 Returns the count for `word` seen during training. 

<a class="entityLink" href="https://github.com/vzhong/torchlib/blob/975ba472d6e4fdaa1f6c82e04d3ff16b691aaa02/vocab.lua#L32">[src]</a>
<a name="torchlib.Vocab:size"></a>


### torchlib.Vocab:size() ###

 Returns how many distinct tokens are in the vocabulary. 

<a class="entityLink" href="https://github.com/vzhong/torchlib/blob/975ba472d6e4fdaa1f6c82e04d3ff16b691aaa02/vocab.lua#L37">[src]</a>
<a name="torchlib.Vocab:add"></a>


### torchlib.Vocab:add(word, count) ###

 Adds `word` `count` time to the vocabulary. 

<a class="entityLink" href="https://github.com/vzhong/torchlib/blob/975ba472d6e4fdaa1f6c82e04d3ff16b691aaa02/vocab.lua#L53">[src]</a>
<a name="torchlib.Vocab:indexOf"></a>


### torchlib.Vocab:indexOf(word, add) ###

 Returns the index of `word`. If the word is not found, then one of the following occurs:
  - if `add` is `true`, then `word` is added to the vocabulary with count 1 and the new index returned
  - otherwise, the index of the unknown token is returned


<a class="entityLink" href="https://github.com/vzhong/torchlib/blob/975ba472d6e4fdaa1f6c82e04d3ff16b691aaa02/vocab.lua#L65">[src]</a>
<a name="torchlib.Vocab:wordAt"></a>


### torchlib.Vocab:wordAt(index) ###

 Returns the word at index `index`. If `index` is out of bounds then an error will be raised. 

<a class="entityLink" href="https://github.com/vzhong/torchlib/blob/975ba472d6e4fdaa1f6c82e04d3ff16b691aaa02/vocab.lua#L71">[src]</a>
<a name="torchlib.Vocab:indicesOf"></a>


### torchlib.Vocab:indicesOf(words, add) ###

 `indexOf` on a table of words. Returns a table of corresponding indices. 

<a class="entityLink" href="https://github.com/vzhong/torchlib/blob/975ba472d6e4fdaa1f6c82e04d3ff16b691aaa02/vocab.lua#L81">[src]</a>
<a name="torchlib.Vocab:tensorIndicesOf"></a>


### torchlib.Vocab:tensorIndicesOf(words, add) ###

 `indexOf` on a table of words. Returns a tensor of corresponding indices. 

<a class="entityLink" href="https://github.com/vzhong/torchlib/blob/975ba472d6e4fdaa1f6c82e04d3ff16b691aaa02/vocab.lua#L91">[src]</a>
<a name="torchlib.Vocab:wordsAt"></a>


### torchlib.Vocab:wordsAt(indices) ###

 `wordAt` on a table of indices. Returns a table of corresponding words. 

<a class="entityLink" href="https://github.com/vzhong/torchlib/blob/975ba472d6e4fdaa1f6c82e04d3ff16b691aaa02/vocab.lua#L100">[src]</a>
<a name="torchlib.Vocab:tensorWordsAt"></a>


### torchlib.Vocab:tensorWordsAt(indices) ###

 `wordAt` on a tensor of indices. Returns a table of corresponding words. 

<a class="entityLink" href="https://github.com/vzhong/torchlib/blob/975ba472d6e4fdaa1f6c82e04d3ff16b691aaa02/vocab.lua#L109">[src]</a>
<a name="torchlib.Vocab:copyAndPruneRares"></a>


### torchlib.Vocab:copyAndPruneRares(cutoff) ###

 Returns a new vocabulary with words occurring less than `cutoff` times removed. 

<a class="entityLink" href="https://github.com/vzhong/torchlib/blob/975ba472d6e4fdaa1f6c82e04d3ff16b691aaa02/vocab.lua#L124">[src]</a>
<a name="torchlib.Vocab:pretrained"></a>


### torchlib.Vocab:pretrained(folder) ###

 Returns the embedding matrix corresponding to this vocabulary. The `folder` must contain:
  - `words.lst`: each line contains a word in the vocabulary
  - `embeddings.txt`: each line contains a vector corresponding to the word on the same line

