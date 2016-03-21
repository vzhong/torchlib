local Vocab = require('torchlib').Vocab

local TestVocab = torch.TestSuite()
local tester = torch.Tester()

function TestVocab.testInit()
  local v = Vocab.new()
  tester:assertTableEq(v.index2word, {'UNK'}, "index2word of empty")
  tester:assertTableEq(v.word2index, {UNK=1}, "word2index of empty")
  tester:assertTableEq(v.counter, {UNK=0}, "count of empty vocab")

  -- with unk
  v = Vocab("UNKNOWN")
  tester:assertTableEq(v.index2word, {"UNKNOWN"}, "index2word of empty vocab with unk")
  tester:assertTableEq(v.word2index, {UNKNOWN=1}, "word2index of empty vocab with unk")
  tester:assertTableEq(v.counter, {UNKNOWN=0}, "counter of empty vocab with unk")
end

function TestVocab.testAdd()
  local v = Vocab()
  local index = v:add("foo")
  tester:asserteq(index, 2)
  tester:assertTableEq(v.index2word, {'UNK', "foo"}, "index2word after add")
  tester:assertTableEq(v.word2index, {UNK=1, foo=2}, "word2index after add")
  tester:assertTableEq(v.counter, {UNK=0, foo=1}, "counter after add")
end

function TestVocab.testContains()
  local v = Vocab('unk')
  tester:assert(v:contains('unk') == true, 'contains of unk')
  tester:assert(v:contains('foo') == false, 'contains before add')
  v:add("foo")
  tester:assert(v:contains('foo') == true, 'contains after add')
end

function TestVocab.testCount()
  local v = Vocab('unk')
  tester:asserteq(v:count('unk'), 0)
  local status, err = pcall(v.count, v, 'foo')
  tester:assert(string.match(err, 'Error: attempted to get count of word foo which is not in the vocabulary') ~= nil)
  v:add('foo', 2)
  tester:asserteq(v:count('foo'), 2)
  v:add('foo', 0)
  tester:asserteq(v:count('foo'), 2)
  v:add('foo', 1)
  tester:asserteq(v:count('foo'), 3)
end

function TestVocab.testSize()
  v = Vocab()
  tester:asserteq(v:size(), 1)
  v:add('foo', 2)
  tester:asserteq(v:size(), 2)
  v:add('foo', 2)
  tester:asserteq(v:size(), 2)
  v:add('bar', 1)
  tester:asserteq(v:size(), 3)
end

function TestVocab.testWordAt()
  local v = Vocab('unk')
  local status, err = pcall(v.wordAt, v, 2)
  tester:assert(string.match(err, 'Error: attempted to get word at index 2 which exceeds the vocab size') ~= nil)
  tester:asserteq(v:wordAt(1), 'unk')
  v:add('bar')
  tester:asserteq(v:wordAt(2), 'bar')
end

function TestVocab.testIndexOf()
  local v = Vocab()
  v:add('bar')
  tester:asserteq(v:indexOf('bar'), 2)

  -- with add
  local v = Vocab()
  v:indexOf('bar', true)
  tester:asserteq(v:indexOf('bar'), 2)

  -- with unk
  v = Vocab('unk')
  tester:asserteq(v:indexOf('bar'), v:indexOf('unk'))
  v:add('bar')
  tester:asserteq(v:indexOf('unk'), 1)
  tester:asserteq(v:indexOf('bar'), 2)
end

function TestVocab.testIndices()
  local v = Vocab()
  v:add('foo')

  -- with add
  tester:assertTableEq(v:indicesOf({'foo', 'bar', 'this', 'this', 'this'}, true), {2, 3, 4, 4, 4})
  tester:asserteq(v:count('foo'), 2)
  tester:asserteq(v:count('bar'), 1)
  tester:asserteq(v:count('this'), 3)
end

function TestVocab.testWordsAt()
  local v = Vocab()
  v:indicesOf({'foo', 'bar', 'this'}, true)
  local status, err = pcall(v.wordsAt, v, {1, 5, 3})
  tester:assert(string.match(err, 'Error: attempted to get word at index 5 which exceeds the vocab size') ~= nil)
  tester:assertTableEq(v:wordsAt({4, 2, 3}), {'this', 'foo', 'bar'})
end

function TestVocab.testCopyAndPruneRares()
  local v = Vocab('unk')
  v:indicesOf({'foo', 'bar', 'this', 'this', 'this', 'bar'}, true)
  local pruned = v:copyAndPruneRares(2)
  tester:assertTableEq(pruned.counter, {unk=0, bar=2, this=3})

  -- with unk
  local v = Vocab('unk')
  v:indicesOf({'foo', 'bar', 'this', 'this', 'this', 'bar'}, true)
  local pruned = v:copyAndPruneRares(2)
  tester:assertTableEq(pruned.counter, {unk=0, bar=2, this=3})
  tester:asserteq(pruned.unk, 'unk')
end

tester:add(TestVocab)
tester:run()
