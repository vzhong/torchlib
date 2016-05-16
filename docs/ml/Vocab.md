# Vocab
Implementation of vocabulary




## Vocab:\_\_init(unk)
[View source](http://github.com/vzhong/torchlib/blob/master/src//ml/Vocab.lua#L9)

Constructor.

Arguments:

- `unk ` (`string`): the symbol for the unknown token. Optional, Default: `'UNK'`.


## Vocab:\_\_tostring\_\_()
[View source](http://github.com/vzhong/torchlib/blob/master/src//ml/Vocab.lua#L22)



Returns:

- (`string`) string representation

## Vocab:contains(word)
[View source](http://github.com/vzhong/torchlib/blob/master/src//ml/Vocab.lua#L28)



Arguments:

- `word ` (`string`): word to query.

Returns:

- (`boolean`) whether `word` is in the vocabulary

## Vocab:count(word)
[View source](http://github.com/vzhong/torchlib/blob/master/src//ml/Vocab.lua#L34)



Arguments:

- `word ` (`string`): word to query.

Returns:

- (`int`) count for `word` seen during training

## Vocab:size()
[View source](http://github.com/vzhong/torchlib/blob/master/src//ml/Vocab.lua#L40)



Returns:

- (`int`) how many distinct tokens are in the vocabulary

## Vocab:add(word, count)
[View source](http://github.com/vzhong/torchlib/blob/master/src//ml/Vocab.lua#L48)

Adds `word` `count` time to the vocabulary.

Arguments:

- `word ` (`string`): word to add.
- `count ` (`int`): number of times to add. Optional, Default: `1`.

Returns:

- (`int`) index of `word`

## Vocab:indexOf(word, add)
[View source](http://github.com/vzhong/torchlib/blob/master/src//ml/Vocab.lua#L79)



Arguments:

- `word ` (`string`): word to query.
- `add ` (`boolean`): whether to add new word to the vocabulary

If the word is not found, then one of the following occurs:

  - if `add` is `true`, then `word` is added to the vocabulary with count 1 and the new index returned

  - otherwise, the index of the unknown token is returned

Example:

Suppose we have a vocabulary of words 'unk', 'foo' and 'bar'. Optional.

Returns:

- (`int`) index of `word`.

```lua
vocab:indexOf('foo') returns 2
vocab:indexOf('bar') returns 3
vocab:indexOf('hello') returns 1 corresponding to `unk` because `hello` is not in the vocabuarly
vocab:indexOf('hello', true) returns 4 because `hello` is added to the vocabulary
```

## Vocab:wordAt(index)
[View source](http://github.com/vzhong/torchlib/blob/master/src//ml/Vocab.lua#L105)



Arguments:

- `index ` (`int`): the index to query

If `index` is out of bounds then an error will be raised.

Example:

Suppose we have a vocabulary with words 'unk', 'foo', and 'bar'.

Returns:

- (`string`) word at index `index`

```lua
vocab:wordAt(1) unk
vocab:wordAt(2) foo
vocab:wordAt(4) raises and error because there is no 4th word in the vocabulary
```

## Vocab:indicesOf(words, add)
[View source](http://github.com/vzhong/torchlib/blob/master/src//ml/Vocab.lua#L122)

`indexOf` on a table of words.

Arguments:

- `words ` (`table[string]`): words to query.
- `add ` (`boolean`): whether to add new words to the vocabulary. Optional.

Returns:

- (`table[int]`) corresponding indices.

Example:

Suppose we have a vocabulary with words 'unk', 'foo', and 'bar'

```lua
vocab:indicesOf{'foo', 'bar'} {2, 3}
```

## Vocab:tensorIndicesOf(words, add)
[View source](http://github.com/vzhong/torchlib/blob/master/src//ml/Vocab.lua#L144)

`indexOf` on a table of words.

Arguments:

- `add ` (`boolean`): whether to add new words to the vocabulary. Optional.

Returns:

- (`torch.Tensor`) tensor of corresponding indices

Example:

Suppose we have a vocabulary with words 'unk', 'foo', and 'bar'

{table[string]} words - words to query

```lua
vocab:tensorIndicesOf{'foo', 'bar'} torch.Tensor{2, 3}
vocab:tensorIndicesOf{'foo', 'hi'} torch.Tensor{2, 1}, because `hi` is not in the vocabulary
```

## Vocab:wordsAt(indices)
[View source](http://github.com/vzhong/torchlib/blob/master/src//ml/Vocab.lua#L165)

`wordAt` on a table of indices.

Arguments:

- `indices ` (`table[int]`): indices to query.

Returns:

- (`table[string]`) corresponding words

Example:

Suppose we have a vocabulary with words 'unk', 'foo', and 'bar'

```lua
vocab:wordsAt{1, 3} {'unk', 'bar'}
vocab:wordsAt{1, 4} raises an error because there is no 4th word
```

## Vocab:tensorWordsAt(indices)
[View source](http://github.com/vzhong/torchlib/blob/master/src//ml/Vocab.lua#L182)

`wordAt` on a tensor of indices. Returns a table of corresponding words.

Example:

Suppose we have a vocabulary with words 'unk', 'foo', and 'bar'

```lua
vocab:tensorWordsAt(torch.Tensor{1, 3}) {'unk', 'bar'}
vocab:tensorWordsAt(torch.Tensor{1, 4}) raises an error because there is no 4th word
```

## Vocab:copyAndPruneRares(cutoff)
[View source](http://github.com/vzhong/torchlib/blob/master/src//ml/Vocab.lua#L201)

Returns a new vocabulary with words occurring less than `cutoff` times removed.

Arguments:

- `cutoff ` (`int`): words with frequency below this number will be removed from the vocabulary.

Returns:

- (`Vocab`) modified vocabulary

Example:

Suppose we want to forget all words that occurred less than 5 times:

```lua
smaller_vocab = orig_vocab:copyAndPruneRares(5)
```

