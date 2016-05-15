local torch = require 'torch'

--- @module Vocab
-- Implementation of vocabulary
local Vocab, parent = torch.class("tl.Vocab", 'tl.Object')

--- Constructor.
-- @arg {string='UNK'} unk - the symbol for the unknown token.
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

--- @returns {string} string representation
function Vocab:__tostring__()
  return parent.__tostring__(self).."("..self:size()..' words, unk='..self.unk..")"
end

--- @returns {boolean} whether `word` is in the vocabulary
-- @arg {string} word - word to query
function Vocab:contains(word)
  return self.word2index[word] ~= nil
end

--- @returns {int} count for `word` seen during training
-- @arg {string} word - word to query
function Vocab:count(word)
  assert(self:contains(word), 'Error: attempted to get count of word ' .. word .. ' which is not in the vocabulary')
  return self.counter[word]
end

--- @returns {int} how many distinct tokens are in the vocabulary
function Vocab:size()
  return #self.index2word
end

--- Adds `word` `count` time to the vocabulary.
-- @arg {string} word - word to add
-- @arg {int=1} count - number of times to add
-- @returns {int} index of `word`
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

--- @returns {int} index of `word`.
-- @arg {string} word - word to query
-- @arg {boolean=} add - whether to add new word to the vocabulary
-- 
-- If the word is not found, then one of the following occurs:
-- 
--   - if `add` is `true`, then `word` is added to the vocabulary with count 1 and the new index returned
-- 
--   - otherwise, the index of the unknown token is returned
-- 
-- Example:
-- 
-- Suppose we have a vocabulary of words 'unk', 'foo' and 'bar'
-- 
-- @code {lua}
-- vocab:indexOf('foo') -- returns 2
-- vocab:indexOf('bar') -- returns 3
-- vocab:indexOf('hello') -- returns 1 corresponding to `unk` because `hello` is not in the vocabuarly
-- vocab:indexOf('hello', true) -- returns 4 because `hello` is added to the vocabulary
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

--- @returns {string} word at index `index`
-- @arg {int} index - the index to query
-- 
-- If `index` is out of bounds then an error will be raised.
-- 
-- Example:
-- 
-- Suppose we have a vocabulary with words 'unk', 'foo', and 'bar'
-- 
-- @code {lua}
-- vocab:wordAt(1) -- unk
-- vocab:wordAt(2) -- foo
-- vocab:wordAt(4) -- raises and error because there is no 4th word in the vocabulary
function Vocab:wordAt(index)
  assert(index <= self:size(), 'Error: attempted to get word at index ' .. index .. ' which exceeds the vocab size')
  return self.index2word[index]
end

--- `indexOf` on a table of words.
-- 
-- @arg {table[string]} words - words to query
-- @arg {boolean=} add - whether to add new words to the vocabulary
-- @returns {table[int]} corresponding indices.
-- 
-- Example:
-- 
-- Suppose we have a vocabulary with words 'unk', 'foo', and 'bar'
-- 
-- @code {lua}
-- vocab:indicesOf{'foo', 'bar'} -- {2, 3}
function Vocab:indicesOf(words, add)
  add = add or false
  indices = {}
  for i, word in ipairs(words) do
    table.insert(indices, self:indexOf(word, add))
  end
  return indices
end

--- `indexOf` on a table of words.
--
-- @args {table[string]} words - words to query
-- @arg {boolean=} add - whether to add new words to the vocabulary
-- @returns {torch.Tensor} tensor of corresponding indices
-- 
-- Example:
-- 
-- Suppose we have a vocabulary with words 'unk', 'foo', and 'bar'
-- 
-- @code {lua}
-- vocab:tensorIndicesOf{'foo', 'bar'} -- torch.Tensor{2, 3}
-- vocab:tensorIndicesOf{'foo', 'hi'} -- torch.Tensor{2, 1}, because `hi` is not in the vocabulary
function Vocab:tensorIndicesOf(words, add)
  add = add or false
  local indices = torch.Tensor(#words)
  for i, word in ipairs(words) do
    indices[i] = self:indexOf(word, add)
  end
  return indices
end

--- `wordAt` on a table of indices.
--
-- @arg {table[int]} indices - indices to query
-- @returns {table[string]} corresponding words
-- 
-- Example:
-- 
-- Suppose we have a vocabulary with words 'unk', 'foo', and 'bar'
-- 
-- @code {lua}
-- vocab:wordsAt{1, 3} -- {'unk', 'bar'}
-- vocab:wordsAt{1, 4} -- raises an error because there is no 4th word
function Vocab:wordsAt(indices)
  local words = {}
  for i, index in ipairs(indices) do
    table.insert(words, self:wordAt(index))
  end
  return words
end

--- `wordAt` on a tensor of indices. Returns a table of corresponding words.
-- 
-- Example:
-- 
-- Suppose we have a vocabulary with words 'unk', 'foo', and 'bar'
-- 
-- @code {lua}
-- vocab:tensorWordsAt(torch.Tensor{1, 3}) -- {'unk', 'bar'}
-- vocab:tensorWordsAt(torch.Tensor{1, 4}) -- raises an error because there is no 4th word
function Vocab:tensorWordsAt(indices)
  local words = {}
  for i = 1, indices:size(1) do
    table.insert(words, self:wordAt(indices[i]))
  end
  return words
end

--- Returns a new vocabulary with words occurring less than `cutoff` times removed.
-- 
-- @arg {int} cutoff - words with frequency below this number will be removed from the vocabulary
-- @returns {Vocab} modified vocabulary
-- 
-- Example:
-- 
-- Suppose we want to forget all words that occurred less than 5 times:
-- 
-- @code {lua}
-- smaller_vocab = orig_vocab:copyAndPruneRares(5)
function Vocab:copyAndPruneRares(cutoff)
  local v = self.new(self.unk)
  for i, word in ipairs(self.index2word) do
    local count = self:count(word)
    if (count >= cutoff or word == self.unk) then
      v:add(word, count)
    end
  end
  return v
end

return Vocab
