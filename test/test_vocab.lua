require 'torchlib'

local TestVocab = {}
local tester

function TestVocab.testInit()
  local v = Vocab.new()
  tester:assertTableEq(v.index2word, {}, "index2word of empty")
  tester:assertTableEq(v.word2index, {}, "word2index of empty")
  tester:assertTableEq(v.counter, {}, "count of empty vocab")

  -- with unk
  v = Vocab.new("UNKNOWN")
  tester:assertTableEq(v.index2word, {"UNKNOWN"}, "index2word of empty vocab with unk")
  tester:assertTableEq(v.word2index, {UNKNOWN=1}, "word2index of empty vocab with unk")
  tester:assertTableEq(v.counter, {UNKNOWN=0}, "counter of empty vocab with unk")
end

function TestVocab.testAdd()
  local v = Vocab.new()
  local index = v:add("foo")
  tester:asserteq(index, 1)
  tester:assertTableEq(v.index2word, {"foo"}, "index2word after add")
  tester:assertTableEq(v.word2index, {foo=1}, "word2index after add")
  tester:assertTableEq(v.counter, {foo=1}, "counter after add")
end

function TestVocab.testContains()
  local v = Vocab.new('unk')
  tester:assert(v:contains('unk'), 'contains of unk')
  tester:assert(v:contains('foo') == false, 'contains before add')
  v:add("foo")
  tester:assert(v:contains('foo'), 'contains after add')
end

function TestVocab.testCount()
  local v = Vocab.new('unk')
  tester:asserteq(v:count('unk'), 0)
  local status, err = pcall(v.count, v, 'foo')
  tester:assert(string.match(err, 'Error: attempted to get count of word foo which is not in the vocabulary'))
  v:add('foo', 2)
  tester:asserteq(v:count('foo'), 2)
  v:add('foo', 0)
  tester:asserteq(v:count('foo'), 2)
  v:add('foo', 1)
  tester:asserteq(v:count('foo'), 3)
end

function TestVocab.testSize()
  local v = Vocab.new()
  tester:asserteq(v:size(), 0)
  v = Vocab.new('unk')
  tester:asserteq(v:size(), 1)
  v:add('foo', 2)
  tester:asserteq(v:size(), 2)
  v:add('foo', 2)
  tester:asserteq(v:size(), 2)
  v:add('bar', 1)
  tester:asserteq(v:size(), 3)
end

function TestVocab.testWordAt()
  local v = Vocab.new('unk')
  local status, err = pcall(v.wordAt, v, 2)
  tester:assert(string.match(err, 'Error: attempted to get word at index 2 which exceeds the vocab size'))
  tester:asserteq(v:wordAt(1), 'unk')
  v:add('bar')
  tester:asserteq(v:wordAt(2), 'bar')
end

function TestVocab.testIndexOf()
  local v = Vocab.new()
  local status, err = pcall(v.indexOf, v, 'bar')
  tester:assert(string.match(err, 'Error: attempted to get index of word bar which is not in the vocabulary'))
  v:add('bar')
  tester:asserteq(v:indexOf('bar'), 1)

  -- with add
  local v = Vocab.new()
  v:indexOf('bar', true)
  tester:asserteq(v:indexOf('bar'), 1)

  -- with unk
  v = Vocab.new('unk')
  tester:asserteq(v:indexOf('bar'), v:indexOf('unk'))
  v:add('bar')
  tester:asserteq(v:indexOf('unk'), 1)
  tester:asserteq(v:indexOf('bar'), 2)
end

function TestVocab.testIndices()
  local v = Vocab.new()
  v:add('foo')
  local status, err = pcall(v.indicesOf, v, {'foo', 'bar', 'this'})
  tester:assert(string.match(err, 'Error: attempted to get index of word bar which is not in the vocabulary'))

  -- with add
  tester:assertTableEq(v:indicesOf({'foo', 'bar', 'this', 'this', 'this'}, true), {1, 2, 3, 3, 3})
  tester:asserteq(v:count('foo'), 2)
  tester:asserteq(v:count('bar'), 1)
  tester:asserteq(v:count('this'), 3)

  -- with unk
  v = Vocab.new('unk')
  v:add('bar')
  tester:assertTableEq(v:indicesOf({'foo', 'bar', 'this'}), {1, 2, 1})
end

function TestVocab.testWordsAt()
  local v = Vocab.new()
  v:indicesOf({'foo', 'bar', 'this'}, true)
  local status, err = pcall(v.wordsAt, v, {1, 4, 3})
  tester:assert(string.match(err, 'Error: attempted to get word at index 4 which exceeds the vocab size'))
  tester:assertTableEq(v:wordsAt({3, 1, 2}), {'this', 'foo', 'bar'})
end

function TestVocab.testCopyAndPruneRares()
  local v = Vocab.new()
  v:indicesOf({'foo', 'bar', 'this', 'this', 'this', 'bar'}, true)
  local pruned = v:copyAndPruneRares(2)
  tester:assertTableEq(pruned.counter, {bar=2, this=3})

  -- with unk
  v = Vocab.new('unk')
  v:indicesOf({'foo', 'bar', 'this', 'this', 'this', 'bar'}, true)
  local pruned = v:copyAndPruneRares(2)
  tester:assertTableEq(pruned.counter, {unk=0, bar=2, this=3})
  tester:asserteq(pruned.unk, 'unk')
end

tester = torch.Tester()
tester:add(TestVocab)
tester:run()
