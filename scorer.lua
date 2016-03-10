--[[ Implementation of a scorer to calculate precision/recall/f1. ]]
local Scorer = torch.class('Scorer')

--[[ Constructor.

Parameters:
- `gold_log` (optional): If given, gold labels will be written to this file
- `pred_log` (optional): If given, predicted labels will be written to this file

]]
function Scorer:__init(gold_log, pred_log)
  if gold_log and pred_log then
    self.logs = {gold = io.open(gold_log, 'w'), pred = io.open(pred_log, 'w')}
  end
  self.class2ind = {}
  self.ind2class = {}
  self.pred = {}
  self.gold = {}
end

--[[ Adds a prediction/ground truth pair to the scorer.

Parameters:
- `gold`: ground truth label
- `pred`: corresponding predicted label
- `id` (optional): corresponding identifier for this example

If the scorer was given the gold log and the pred log, then the pair will be written to their respective log files.
]]

function Scorer:add_pred(gold, pred, id)
  if self.logs then
    self.logs.gold:write(id..'\t'..gold..'\n')
    self.logs.pred:write(id..'\t'..pred..'\n')
  end
  if not self.class2ind[gold] then
    table.insert(self.ind2class, gold)
    self.class2ind[gold] = #self.ind2class
  end
  if not self.class2ind[pred] then
    table.insert(self.ind2class, pred)
    self.class2ind[pred] = #self.ind2class
  end
  table.insert(self.gold, self.class2ind[gold])
  table.insert(self.pred, self.class2ind[pred])
end

--[[ Removes all remembered statistics from the scorer. ]]
function Scorer:reset()
  if self.logs then
    for fname, f in pairs(self.logs) do
      f:close()
      self.logs[fname] = io.open(fname .. '.log', 'w')
    end
  end
  self.class2ind, self.ind2class, self.pred, self.gold = {}, {}, {}, {}
end

--[[ Computes the precision/recall/f1 statistics for the current batch of elements.

Parameters:
- `ignore` (optional): If given, `ignore` is taken to be the "negative" class and its statistics will be withheld from the computation.

Returns a tuple:
- `micro`: the micro averaged precision/recall/f1 statistics
- `macro`: the macro averaged precision/recall/f1 statistics
- `class_stats`: the precision/recall/f1 for each class
]]
function Scorer:precision_recall_f1(ignore)
  local pred = torch.Tensor(self.pred)
  local gold = torch.Tensor(self.gold)
  local all_stats = {}
  local collapsed_classes = {}
  for class, ind in pairs(self.class2ind) do
    local relevant = gold:eq(ind)
    local retrieved = pred:eq(ind)
    local stats = {
      relevant = relevant:sum(),
      retrieved = retrieved:sum(),
      relevant_and_retrieved = torch.cmul(relevant, retrieved):sum(),
    }
    stats.precision = stats.relevant_and_retrieved / stats.retrieved
    stats.recall = stats.relevant_and_retrieved / stats.relevant
    if stats.retrieved == 0 then stats.precision = 0 end
    if stats.relevant == 0 then stats.recall = 0 end
    stats.f1 = 2 * stats.precision * stats.recall / (stats.precision + stats.recall)
    all_stats[class] = stats
  end
  local macro = {precision=0, recall=0}
  local micro = {relevant=0, retrieved=0, relevant_and_retrieved=0}
  for class, s in pairs(all_stats) do
    if class ~= ignore then
      for _, k in ipairs{'precision', 'recall'} do
        macro[k] = macro[k] + s[k] / #self.ind2class
      end
      for _, k in ipairs{'relevant', 'retrieved', 'relevant_and_retrieved'} do
        micro[k] = micro[k] + s[k]
      end
    end
  end
  macro.f1 = 2 * macro.precision * macro.recall / (macro.precision + macro.recall)
  micro.precision = micro.relevant_and_retrieved / micro.retrieved
  micro.recall = micro.relevant_and_retrieved / micro.relevant
  micro.f1 = 2 * micro.precision * micro.recall / (micro.precision + micro.recall)
  return micro, macro, all_stats
end

return Scorer
