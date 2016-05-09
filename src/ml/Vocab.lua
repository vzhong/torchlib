--[[ Implementation of a vocabulary class ]]
local Vocab, parent = torch.class("tl.Vocab", 'tl.Object')

--[[ Constructor.

  Parameters:

  - `unk`: the symbol for the unknown token.
]]
function Vocab:__init(unk)
  self.unk = unk or 'UNK'
  self.index2word = {}
  self.word2index = {}
  self.counter = {}
  if self.unk ~= nil then
    table.insert(self.index2word, self.unk)
    self.word2index[self.unk] = self:size()
    self.counter[self.unk] = 0;
  end
end

function Vocab:__tostring__()
  return parent.__tostring__(self).."("..self:size()..' words, unk='..self.unk..")"
end

--[[ Returns whether `word` is in the vocabulary. ]]
function Vocab:contains(word)
  return self.word2index[word] ~= nil
end

--[[ Returns the count for `word` seen during training. ]]
function Vocab:count(word)
  assert(self:contains(word), 'Error: attempted to get count of word ' .. word .. ' which is not in the vocabulary')
  return self.counter[word]
end

--[[ Returns how many distinct tokens are in the vocabulary. ]]
function Vocab:size()
  return #self.index2word
end

--[[ Adds `word` `count` time to the vocabulary. ]]
function Vocab:add(word, count)
  count = count or 1
  if self:contains(word) then
    self.counter[word] = self:count(word) + count
  else
    self.counter[word] = count
    table.insert(self.index2word, word)
    self.word2index[word] = self:size()
  end
  return self.word2index[word]
end

--[[ Returns the index of `word`.

If the word is not found, then one of the following occurs:

  - if `add` is `true`, then `word` is added to the vocabulary with count 1 and the new index returned

  - otherwise, the index of the unknown token is returned


Example:

Suppose we have a vocabulary of words 'unk', 'foo' and 'bar'

```
vocab:indexOf('foo') -- returns 2
vocab:indexOf('bar') -- returns 3
vocab:indexOf('hello') -- returns 1 corresponding to `unk` because `hello` is not in the vocabuarly
vocab:indexOf('hello', true) -- returns 4 because `hello` is added to the vocabulary
```
]]
function Vocab:indexOf(word, add)
  add = add or false
  if add then
    return self:add(word, 1)
  end
  if not self:contains(word) then
    self.counter[self.unk] = self:count(self.unk) + 1
    return self:indexOf(self.unk)
  end
  self.counter[word] = self:count(word) + 1
  return self.word2index[word]
end

--[[ Returns the word at index `index`.

If `index` is out of bounds then an error will be raised.

Example:

Suppose we have a vocabulary with words 'unk', 'foo', and 'bar'

```
vocab:wordAt(1) -- unk
vocab:wordAt(2) -- foo
vocab:wordAt(4) -- raises and error because there is no 4th word in the vocabulary
```
]]
function Vocab:wordAt(index)
  assert(index <= self:size(), 'Error: attempted to get word at index ' .. index .. ' which exceeds the vocab size')
  return self.index2word[index]
end

--[[ `indexOf` on a table of words. Returns a table of corresponding indices.

Example:

Suppose we have a vocabulary with words 'unk', 'foo', and 'bar'

```
vocab:indicesOf{'foo', 'bar'} -- {2, 3}
```
]]
function Vocab:indicesOf(words, add)
  add = add or false
  indices = {}
  for i, word in ipairs(words) do
    table.insert(indices, self:indexOf(word, add))
  end
  return indices
end

--[[ `indexOf` on a table of words. Returns a tensor of corresponding indices.

Example:

Suppose we have a vocabulary with words 'unk', 'foo', and 'bar'

```
vocab:tensorIndicesOf{'foo', 'bar'} -- torch.Tensor{2, 3}
vocab:tensorIndicesOf{'foo', 'hi'} -- torch.Tensor{2, 1}, because `hi` is not in the vocabulary
```
]]
function Vocab:tensorIndicesOf(words, add)
  add = add or false
  indices = torch.Tensor(#words)
  for i, word in ipairs(words) do
    indices[i] = self:indexOf(word, add)
  end
  return indices
end

--[[ `wordAt` on a table of indices. Returns a table of corresponding words.

Example:

Suppose we have a vocabulary with words 'unk', 'foo', and 'bar'

```
vocab:wordsAt{1, 3} -- {'unk', 'bar'}
vocab:wordsAt{1, 4} -- raises an error because there is no 4th word
```
]]
function Vocab:wordsAt(indices)
  words = {}
  for i, index in ipairs(indices) do
    table.insert(words, self:wordAt(index))
  end
  return words
end

--[[ `wordAt` on a tensor of indices. Returns a table of corresponding words.

Example:

Suppose we have a vocabulary with words 'unk', 'foo', and 'bar'

```
vocab:tensorWordsAt(torch.Tensor{1, 3}) -- {'unk', 'bar'}
vocab:tensorWordsAt(torch.Tensor{1, 4}) -- raises an error because there is no 4th word
```
]]
function Vocab:tensorWordsAt(indices)
  words = {}
  for i = 1, indices:size(1) do
    table.insert(words, self:wordAt(indices[i]))
  end
  return words
end

--[[ Returns a new vocabulary with words occurring less than `cutoff` times removed.

Example:

Suppose we want to forget all words that occurred less than 5 times:

```
smaller_vocab = orig_vocab:copyAndPruneRares(5)
```
]]
function Vocab:copyAndPruneRares(cutoff)
  v = self.new(self.unk)
  for i, word in ipairs(self.index2word) do
    count = self:count(word)
    if (count >= cutoff or word == self.unk) then
      v:add(word, count)
    end
  end
  return v
end

return Vocab
