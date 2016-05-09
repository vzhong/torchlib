# Torchlib

[![wercker status](https://app.wercker.com/status/c7bd97d06535598d96937e0cf5ace629/m "wercker status")](https://app.wercker.com/project/bykey/c7bd97d06535598d96937e0cf5ace629)

[![codecov](https://codecov.io/gh/vzhong/torchlib/branch/master/graph/badge.svg)](https://codecov.io/gh/vzhong/torchlib)

[View documentation](http://www.victorzhong.com/torchlib/tl/index.html).

Data structures and libraries for Torch. All instances are Torch serializable with `torch.save` and `torch.load`.


## Installation

You can install `torchlib` as follows:

`git clone https://github.com/vzhong/torchlib.git && cd torchlib && luarocks make`

Torchlib is namespaced locally. To use it:

```lua
local tl = require 'torchlib'

local m = tl.DirectedGraph()
...
```

Examples and use cases are shown in the documentation.


## Overview

Torchlib's can be divided into categories based on usecases.

### Basic Datastructures and Algorithms

- [Graphs](http://www.victorzhong.com/torchlib/tl/index.html#tl.src.graph.DirectedGraph.dok)
- [Lists, heaps, queues, and stacks](http://www.victorzhong.com/torchlib/tl/index.html#tl.src.list.ArrayList.dok)
- [Maps and counters](http://www.victorzhong.com/torchlib/tl/index.html#tl.src.map.Counter.dok)
- [Sets](http://www.victorzhong.com/torchlib/tl/index.html#tl.src.set.Set.dok)
- [Trees](http://www.victorzhong.com/torchlib/tl/index.html#tl.src.tree.BinarySearchTree.dok)

### Machine Learning

The [machine learning package](http://www.victorzhong.com/torchlib/tl/index.html#tl.src.ml.Dataset.dok) contains utilities that facilitate the training of and evaluation of machine learning models. These include:

- [Dataset](http://www.victorzhong.com/torchlib/tl/index.html#tl.src.ml.Dataset.dok), which provides mechanisms for subsampling, shuffling, batching of arbitrary examples.
- [Vocab](http://www.victorzhong.com/torchlib/tl/index.html#tl.src.ml.Vocab.dok), for mapping between indices and words
- [Model](http://www.victorzhong.com/torchlib/tl/index.html#tl.src.ml.Model.dok), an abstract class to facilitate the training of Torch based machine learning models
- [Scorer](http://www.victorzhong.com/torchlib/tl/index.html#tl.src.ml.Scorer.dok), for evaluating precision/recall metrics
- [Experiment](http://www.victorzhong.com/torchlib/tl/index.html#tl.src.ml.Experiment.dok), for logging experiment progress to a postgres instance.

### Utilities

- [Downloader](http://www.victorzhong.com/torchlib/tl/index.html#tl.Downloader), for downloading content via http.
- [Global](http://www.victorzhong.com/torchlib/tl/index.html#tl.range), global convenience functions namespaced under `tl`.
- [String](http://www.victorzhong.com/torchlib/tl/index.html#tl.string.startswith), string convenience functions namespaced under `tl.string` and monkeypatched into `string`.
- [Table](http://www.victorzhong.com/torchlib/tl/index.html#tl.table.tostring), table convenience functions namespaced under `tl.table` and monkeypatched into `table`.

## Documentation

The documentation is hosted [here](http://www.victorzhong.com/torchlib/tl/index.html).
Alternatively you can build your own documentation with `torch-dokx`, which you can get [here](https://github.com/deepmind/torch-dokx).


## Contribution

Pull requests are welcome! Torchlib is unit tested with the default Torch testing framework. Continuous integration is hosted on [Wercker](http://wercker.com/) which also automatically builds the documentations and deploys them on Github pages (of this repo).
