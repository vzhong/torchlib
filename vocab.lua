local Vocab = torch.class("Vocab")

function Vocab:__init(unk)
  self.unk = unk or nil
  self.index2word = {}
  self.word2index = {}
  self.counter = {}
  if self.unk ~= nil then
    table.insert(self.index2word, self.unk)
    self.word2index[self.unk] = self:size()
    self.counter[self.unk] = 0;
  end
end

function Vocab:contains(word)
  return self.word2index[word] ~= nil
end

function Vocab:count(word)
  assert(self:contains(word), 'Error: attempted to get count of word ' .. word .. ' which is not in the vocabulary')
  return self.counter[word]
end

function Vocab:size()
  return #self.index2word
end

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

function Vocab:indexOf(word, add)
  add = add or false
  if add then
    self:add(word, 1)
  end
  if self.unk == nil then
    assert(self:contains(word), 'Error: attempted to get index of word ' .. word .. ' which is not in the vocabulary')
  else
    if not self:contains(word) then
      return self:indexOf(self.unk)
    end
  end
  return self.word2index[word]
end

function Vocab:wordAt(index)
  assert(index <= self:size(), 'Error: attempted to get word at index ' .. index .. ' which exceeds the vocab size')
  return self.index2word[index]
end

function Vocab:indicesOf(words, add)
  add = add or false
  indices = {}
  for i, word in ipairs(words) do
    table.insert(indices, self:indexOf(word, add))
  end
  return indices
end

function Vocab:wordsAt(indices)
  words = {}
  for i, index in ipairs(indices) do
    table.insert(words, self:wordAt(index))
  end
  return words
end

function Vocab:copyAndPruneRares(cutoff)
  v = Vocab.new(self.unk)
  for i, word in ipairs(self.index2word) do
    count = self:count(word)
    if (count >= cutoff or word == self.unk) then
      v:add(word, count)
    end
  end
  return v
end

