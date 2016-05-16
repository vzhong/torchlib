# GloveVocab
Vocab object prepopulated with Glove embeddings by Pennington, Socher, and Manning.
This is a subclass of `Vocab`.
For details, see:



http://nlp.stanford.edu/projects/glove/.

This only supports the 50-d wikipedia/Giga-word version.

The download is from:

https://dl.dropboxusercontent.com/u/9015381/datasets/torchnlp/glove.6B.50d.t7

## GloveVocab:load\_words()
[View source](http://github.com/vzhong/torchlib/blob/master/src//ml/GloveVocab.lua#L18)

Retrieves the word list and populates the vocabulary.


## GloveVocab:embeddings()
[View source](http://github.com/vzhong/torchlib/blob/master/src//ml/GloveVocab.lua#L29)



Returns:

- (`torch.Tensor`) pretrained embeddings for words in the vocabulary

## GloveVocab:\_\_tostring\_\_()
[View source](http://github.com/vzhong/torchlib/blob/master/src//ml/GloveVocab.lua#L47)



Returns:

- (`string`) string representation

