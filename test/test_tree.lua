require 'torchlib'

local TestTree = torch.TestSuite()
local TestBinaryTree = torch.TestSuite()
local tester = torch.Tester()

function TestTree.testToString()
  local node = BinaryTreeNode(5, 'hi')
  tester:asserteq('BinaryTreeNode<hi(5)>', tostring(node))
end

function TestTree.testWalkInOrder()
  local t = BinarySearchTree.fake()
  local ordered = {}
  t:walkInOrder(function(n) table.insert(ordered, n) end)
  local tab = {2, 5, 9, 12, 13, 15, 17, 18, 19}
  for i, v in ipairs(tab) do
    tester:asserteq(v, ordered[i].val)
  end
end

function TestBinaryTree.testInsert()
  local a = BinarySearchTreeNode(2, 'a')
  local tree = BinarySearchTree()
  tester:asserteq(0, tree:size())

  tree:insert(a)
  tester:asserteq(1, tree:size())
  tester:asserteq(a, tree.root)

  local b = BinarySearchTreeNode(1, 'b')
  tree:insert(b)
  tester:asserteq(2, tree:size())
  tester:asserteq(b, tree.root.left)
  tester:asserteq(b, a.left)

  local c = BinarySearchTreeNode(3, 'c')
  tree:insert(c)
  tester:asserteq(3, tree:size())
  tester:asserteq(c, tree.root.right)
  tester:asserteq(c, a.right)

  local d = BinarySearchTreeNode(4, 'd')
  tree:insert(d)
  tester:asserteq(4, tree:size())
  tester:asserteq(d, tree.root.right.right)
  tester:asserteq(d, c.right)
end

function TestBinaryTree.testSearch()
  local tree = BinarySearchTree.fake()
  tester:asserteq(nil, tree:search(-1))
  tester:asserteq(12, tree:search(12).key)
end

function TestBinaryTree.testMin()
  local tree = BinarySearchTree.fake()
  tester:asserteq(2, tree:min().key)
end

function TestBinaryTree.testMax()
  local tree = BinarySearchTree.fake()
  tester:asserteq(19, tree:max().key)
end

function TestBinaryTree.testSuccessor()
  local tree = BinarySearchTree.fake()
  tester:asserteq(5, tree:search(2):successor().key)
  tester:asserteq(9, tree:search(5):successor().key)
  tester:asserteq(12, tree:search(9):successor().key)
  tester:asserteq(13, tree:search(12):successor().key)
  tester:asserteq(15, tree:search(13):successor().key)
  tester:asserteq(17, tree:search(15):successor().key)
  tester:asserteq(18, tree:search(17):successor().key)
  tester:asserteq(19, tree:search(18):successor().key)
  tester:asserteq(nil, tree:search(19):successor())
end

function TestBinaryTree.testPredecssor()
  local tree = BinarySearchTree.fake()
  tester:asserteq(nil, tree:search(2):predecessor())
  tester:asserteq(2, tree:search(5):predecessor().key)
  tester:asserteq(5, tree:search(9):predecessor().key)
  tester:asserteq(9, tree:search(12):predecessor().key)
  tester:asserteq(12, tree:search(13):predecessor().key)
  tester:asserteq(13, tree:search(15):predecessor().key)
  tester:asserteq(15, tree:search(17):predecessor().key)
  tester:asserteq(17, tree:search(18):predecessor().key)
  tester:asserteq(18, tree:search(19):predecessor().key)
end

function TestBinaryTree.testDelete()
  local tree = BinarySearchTree.fake()
  tree:delete(tree:search(13))
  tester:asserteq(12, tree.root.val)
  tester:asserteq(5, tree.root.left.val)
  tester:asserteq(2, tree.root.left.left.val)
  tester:asserteq(9, tree.root.left.right.val)
  tester:asserteq(18, tree.root.right.val)
  tester:asserteq(15, tree.root.right.left.val)
  tester:asserteq(17, tree.root.right.left.right.val)
  tester:asserteq(19, tree.root.right.right.val)
end

tester:add(TestTree)
tester:add(TestBinaryTree)
tester:run()
