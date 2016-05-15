local BinarySearchTree = require('torchlib').BinarySearchTree
local BinaryTreeNode = require('torchlib').BinaryTree.Node
local BinarySearchTreeNode = require('torchlib').BinarySearchTree.Node
local TreeNode = require('torchlib').Tree.Node

local TestTree = torch.TestSuite()
local TestBinaryTree = torch.TestSuite()
local tester = torch.Tester()

local dummyTree = function()
  local t = BinarySearchTree.new()
  t:insert(BinarySearchTreeNode.new(12, 'n1'))
  t:insert(BinarySearchTreeNode.new(5, 'n2'))
  t:insert(BinarySearchTreeNode.new(2, 'n3'))
  t:insert(BinarySearchTreeNode.new(9, 'n4'))
  t:insert(BinarySearchTreeNode.new(18, 'n5'))
  t:insert(BinarySearchTreeNode.new(15, 'n6'))
  t:insert(BinarySearchTreeNode.new(13, 'n7'))
  t:insert(BinarySearchTreeNode.new(17, 'n8'))
  t:insert(BinarySearchTreeNode.new(19, 'n9'))
  return t
end

function TestTree.testToString()
  local node = BinaryTreeNode(5, 'hi')
  tester:asserteq('tl.BinaryTree.Node<hi(5)>', tostring(node))
end

function TestTree.testWalkInOrder()
  local t = dummyTree()
  local ordered = {}
  t:walkInOrder(function(n) table.insert(ordered, n) end)
  local tab = {2, 5, 9, 12, 13, 15, 17, 18, 19}
  for i, v in ipairs(tab) do
    tester:asserteq(v, ordered[i].key)
  end
end

function TestTree.testTreeNode()
  local node = TreeNode.new()
  tester:assertErrorPattern(function() node:children() end, 'not implemented')
end

function TestBinaryTree.testBinaryTreeNode()
  local t = BinaryTreeNode(1, 2)
  tester:asserteq(1, t.key)
  tester:asserteq(2, t.val)

  t.left = BinaryTreeNode(3, 4)
  t.right = BinaryTreeNode(5, 6)
  tester:assertTableEq({t.left, t.right}, t:children())
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
  local tree = dummyTree()
  tester:asserteq(nil, tree:search(-1))
  tester:asserteq(12, tree:search(12).key)
end

function TestBinaryTree.testMin()
  local tree = dummyTree()
  tester:asserteq(2, tree:min().key)
end

function TestBinaryTree.testMax()
  local tree = dummyTree()
  tester:asserteq(19, tree:max().key)
end

function TestBinaryTree.testSuccessor()
  local tree = dummyTree()
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
  local tree = dummyTree()
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
  local tree = dummyTree()
  tree:delete(tree:search(13))
  tester:asserteq(12, tree.root.key)
  tester:asserteq(5, tree.root.left.key)
  tester:asserteq(2, tree.root.left.left.key)
  tester:asserteq(9, tree.root.left.right.key)
  tester:asserteq(18, tree.root.right.key)
  tester:asserteq(15, tree.root.right.left.key)
  tester:asserteq(17, tree.root.right.left.right.key)
  tester:asserteq(19, tree.root.right.right.key)

  tree:delete(tree:search(12))
  tester:asserteq(15, tree.root.key)
  tester:asserteq(5, tree.root.left.key)
  tester:asserteq(2, tree.root.left.left.key)
  tester:asserteq(9, tree.root.left.right.key)
  tester:asserteq(18, tree.root.right.key)
  tester:asserteq(17, tree.root.right.left.key)
  tester:asserteq(19, tree.root.right.right.key)

  tree:delete(tree:search(9))
  tester:asserteq(15, tree.root.key)
  tester:asserteq(5, tree.root.left.key)
  tester:asserteq(2, tree.root.left.left.key)
  tester:asserteq(18, tree.root.right.key)
  tester:asserteq(17, tree.root.right.left.key)
  tester:asserteq(19, tree.root.right.right.key)

  tree:delete(tree:search(5))
  tester:asserteq(15, tree.root.key)
  tester:asserteq(2, tree.root.left.key)
  tester:asserteq(18, tree.root.right.key)
  tester:asserteq(17, tree.root.right.left.key)
  tester:asserteq(19, tree.root.right.right.key)
end

function TestBinaryTree.testToStringBinarySearchTree()
  local tree = dummyTree()
  local expect = [[|__ tl.BinarySearchTree.Node<n1(12)>
    |__ tl.BinarySearchTree.Node<n2(5)>
        |__ tl.BinarySearchTree.Node<n3(2)>
        |__ tl.BinarySearchTree.Node<n4(9)>
    |__ tl.BinarySearchTree.Node<n5(18)>
        |__ tl.BinarySearchTree.Node<n6(15)>
            |__ tl.BinarySearchTree.Node<n7(13)>
            |__ tl.BinarySearchTree.Node<n8(17)>
        |__ tl.BinarySearchTree.Node<n9(19)>
]]
  tester:asserteq(expect, tostring(tree))
end

tester:add(TestTree)
tester:add(TestBinaryTree)
tester:run()
