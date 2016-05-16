# Torchlib

[![wercker status](https://app.wercker.com/status/c7bd97d06535598d96937e0cf5ace629/s/master "wercker status")](https://app.wercker.com/project/bykey/c7bd97d06535598d96937e0cf5ace629)
[![codecov](https://codecov.io/gh/vzhong/torchlib/branch/master/graph/badge.svg)](https://codecov.io/gh/vzhong/torchlib)

[View documentation](http://www.victorzhong.com/torchlib).

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


## Documentation

The documentation is hosted [here](http://www.victorzhong.com/torchlib).
Alternatively you can build your own documentation with `docroc`, which you can get [here](https://github.com/vzhong/docroc).


## Overview

Torchlib's can be divided into categories based on usecases.

### Basic Datastructures and Algorithms

- Graphs
- Lists, heaps, queues and stacks
- Maps and counters
- Sets
- Trees

### Machine Learning

The machine learning package contains utilities that facilitate the training of and evaluation of machine learning models. These include:

- Dataset, which provides mechanisms for subsampling, shuffling, batching of arbitrary examples.
- Vocab, for mapping between indices and words.
- Model, an abstract class to facilitate the training of Torch based machine learning models.
- Scorer, for evaluating precision/recall metrics.
- ProbTable, for modeling probability distributions.
- Experiment, for logging experiment progress to a postgres instance.

### Utilities

- Downloader, for downloading content via http.
- Global, global convenience functions namespaced under `tl`.
- String, string convenience functions namespaced under `tl.string` and monkeypatched into `string`.
- Table, table convenience functions namespaced under `tl.table` and monkeypatched into `table`.


## Contribution

Pull requests are welcome! Torchlib is unit tested with the default Torch testing framework. Continuous integration is hosted on [Wercker](http://wercker.com/) which also automatically builds the documentations and deploys them on Github pages (of this repo).
