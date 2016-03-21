--[[ Vocab object prepopulated with Glove embeddings by Pennington, Socher, and Manning
  For details, see: http://nlp.stanford.edu/projects/glove/.
  This only supports the 50-d wikipedia/Giga-word version.
  The download is from https://dl.dropboxusercontent.com/u/9015381/datasets/torchnlp/glove.6B.50d.t7
]]
local GloveVocab, parent = torch.class('tl.GloveVocab', 'tl.Vocab')

function GloveVocab:load_words()
  local fname = Downloader():get('vocab-glove.6B.50d.t7', 'https://dl.dropboxusercontent.com/u/9015381/datasets/torchnlp/glove.6B.50d.t7')
  local bin = torch.load(fname)
  -- add the pretrained vocabulary
  self:indicesOf(bin.words, true)
end

function GloveVocab:embeddings(t)
  t = t or torch.Tensor(self:size(), 50):uniform(-0.08, 0.08)
  local fname = Downloader():get('vocab-glove.6B.50d.t7', 'https://dl.dropboxusercontent.com/u/9015381/datasets/torchnlp/glove.6B.50d.t7')
  local bin = torch.load(fname)
  local w2i = {}
  for i, word in ipairs(bin.words) do
    w2i[word] = i
  end

  for i, w in ipairs(self.word2index) do
    if w2i[w] then t[i] = bins.vecs[w2i[w]] end
  end

  return t
end

function GloveVocab:tostring()
  return "GloveVocab("..self:size()..' words, unk='..self.unk..")"
end
torch.getmetatable('tl.GloveVocab').__tostring__ = GloveVocab.tostring

return GloveVocab
