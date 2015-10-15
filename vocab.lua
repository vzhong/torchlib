local Vocab = torch.class("Vocab")

function Vocab:__init(opt)
  self.unk = (opt and opt.unk) or nil
  self.skip_dummy = (opt and opt.skip_dummy) or false
  self.index2word = {}
  self.word2index = {}
  self.counter = {}
  if self.unk ~= nil then
    table.insert(self.index2word, self.unk)
    self.word2index[self.unk] = self:size()
    self.counter[self.unk] = 0;
  end

  if not self.skip_dummy then
    self:add('DUMMY')
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
  v = Vocab.new{unk=self.unk, skip_dummy=self.skip_dummy}
  for i, word in ipairs(self.index2word) do
    count = self:count(word)
    if (count >= cutoff or word == self.unk or word == 'DUMMY') then
      v:add(word, count)
    end
  end
  return v
end

function Vocab:pretrained(folder)
  local wordlist = paths.concat(folder, 'words.lst')
  local embeddings = paths.concat(folder, 'embeddings.txt')
  assert(paths.filep(wordlist), 'Error: wordlists does not exist at ' .. wordlist)
  assert(paths.filep(embeddings), 'Error: wordlists does not exist at ' .. embeddings)
  -- add each word in the wordlist
  local words = {}
  for line in io.lines(wordlist) do
    -- remove the last character, which is newline
    local word = string.sub(line, 1, -1)
    table.insert(words, word)
  end
  -- load vectors
  local emb = torch.Tensor(self:size(), 50):uniform(-0.1, 0.1)
  local i = 1
  for line in io.lines(embeddings) do
    -- remove the last character, which is newline
    local numbers = string.split(line, '%s+')
    local word = words[i]
    if self:contains(word) then
      local ind = self:indexOf(word)
      assert(#numbers == 50, 'Error: cannot parse embedding ' .. tostring(line))
      emb[ind] = torch.Tensor(numbers)
    end
    i = i + 1
  end
  return emb
end

