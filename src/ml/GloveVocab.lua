local torch = require 'torch'
local Downloader = tl.Downloader

--- @module GloveVocab
-- Vocab object prepopulated with Glove embeddings by Pennington, Socher, and Manning.
-- This is a subclass of `Vocab`.
-- For details, see:
--
-- http://nlp.stanford.edu/projects/glove/.
--
-- This only supports the 50-d wikipedia/Giga-word version.
-- The download is from:
--
-- https://dl.dropboxusercontent.com/u/9015381/datasets/torchnlp/glove.6B.50d.t7
local GloveVocab, parent = torch.class('tl.GloveVocab', 'tl.Vocab')

--- Retrieves the word list and populates the vocabulary.
function GloveVocab:load_words()
  local fname = Downloader():get(
    'vocab-glove.6B.50d.t7',
    'https://dl.dropboxusercontent.com/u/9015381/datasets/torchnlp/glove.6B.50d.t7'
  )
  local bin = torch.load(fname)
  -- add the pretrained vocabulary
  self:indicesOf(bin.words, true)
end

--- @returns {torch.Tensor} pretrained embeddings for words in the vocabulary
function GloveVocab:embeddings()
  local t = torch.Tensor(self:size(), 50):uniform(-0.08, 0.08)
  local fname = Downloader():get(
    'vocab-glove.6B.50d.t7',
    'https://dl.dropboxusercontent.com/u/9015381/datasets/torchnlp/glove.6B.50d.t7'
  )
  local bin = torch.load(fname)
  local w2i = {}
  for i, word in ipairs(bin.words) do
    w2i[word] = i
  end
  for i, w in ipairs(self.word2index) do
    if w2i[w] then t[i] = bin.vecs[w2i[w]] end
  end
  return t
end

--- @returns {string} string representation
function GloveVocab:__tostring__()
  return "GloveVocab("..self:size()..' words, unk='..self.unk..")"
end

return GloveVocab
