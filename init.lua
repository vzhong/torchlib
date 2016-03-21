require 'torch'

tl = {}

local Object = torch.class('tl.Object')
function Object:tostring()
  return torch.type(self)
end

require('torchlib/src/util/util')
require('torchlib/src/util/Download')

require('torchlib/src/list/List')
require('torchlib/src/list/ArrayList')
require('torchlib/src/list/LinkedList')
require('torchlib/src/list/Queue')
require('torchlib/src/list/Heap')
require('torchlib/src/list/Stack')

require('torchlib/src/tree/Tree')
require('torchlib/src/tree/BinaryTree')
require('torchlib/src/tree/BinarySearchTree')

require('torchlib/src/set/Set')
require('torchlib/src/map/Map')
require('torchlib/src/map/HashMap')
require('torchlib/src/map/Counter')

require('torchlib/src/graph/Graph')
require('torchlib/src/graph/DirectedGraph')
require('torchlib/src/graph/UndirectedGraph')

require('torchlib/src/ml/Dataset')
require('torchlib/src/ml/Vocab')
require('torchlib/src/ml/GloveVocab')
require('torchlib/src/ml/Scorer')
require('torchlib/src/ml/VariableTensor')

return tl
