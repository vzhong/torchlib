local Scorer = require('torchlib').Scorer

local TestScorer = torch.TestSuite()
local tester = torch.Tester()

local toyScorer = function()
  local s = Scorer()
  s:add_pred('a', 'b', 1)
  s:add_pred('b', 'b', 2)
  s:add_pred('c', 'a', 3)
  return s
end

function TestScorer.test_add_pred()
  local s = toyScorer()
  tester:assertTableEq({'a', 'b', 'c'}, s.ind2class)
  tester:assertTableEq({a=1, b=2, c=3}, s.class2ind)
  tester:assertTableEq({1, 2, 3}, s.gold)
  tester:assertTableEq({2, 2, 1}, s.pred)
end

function TestScorer.test_reset()
  local s = toyScorer()
  s:reset()
  tester:assertTableEq({}, s.ind2class)
  tester:assertTableEq({}, s.class2ind)
  tester:assertTableEq({}, s.gold)
  tester:assertTableEq({}, s.pred)
end

function TestScorer.test_precision_recall_f1()
  -- these numbers are tested against Python's sklearn.metrics
  local s = toyScorer()
  local ignore = 'c'
  local micro, macro, all_stats = s:precision_recall_f1(ignore)
  tester:assertTableEq({precision=1/3, recall=1/2, f1=0.4}, micro)
  tester:assertTableEq({precision=0.25, recall=0.5, f1=1/3}, macro)
  tester:assertTableEq({
    a = {precision=0, recall=0, f1=0},
    b = {precision=0.5, recall=1, f1=2/3},
    c = {precision=0, recall=0, f1=0},
  }, all_stats)
end

tester:add(TestScorer)
tester:run()
