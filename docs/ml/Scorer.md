# Scorer
Implementation of a scorer to calculate precision/recall/f1.




## Scorer:\_\_init(gold\_log, pred\_log)
[View source](http://github.com/vzhong/torchlib/blob/master/src//ml/Scorer.lua#L11)

Constructor.

Arguments:

- `gold_log ` (`string`): if given, gold labels will be written to this file. Optional.
- `pred_log ` (`string]`): if given, predicted labels will be written to this file.


## Scorer:add\_pred(gold, pred, id)
[View source](http://github.com/vzhong/torchlib/blob/master/src//ml/Scorer.lua#L27)

Adds a prediction/ground truth pair to the scorer.

Arguments:

- `gold ` (`string`): ground truth label.
- `pred ` (`string`): corresponding predicted label.
- `id ` (`string`): corresponding identifier for this example

If the scorer was given the gold log and the pred log, then the pair will be written to their respective log files. Optional.


## Scorer:reset()
[View source](http://github.com/vzhong/torchlib/blob/master/src//ml/Scorer.lua#L45)

Removes all remembered statistics from the scorer.


## Scorer:precision\_recall\_f1(ignore)
[View source](http://github.com/vzhong/torchlib/blob/master/src//ml/Scorer.lua#L77)

Computes the precision/recall/f1 statistics for the current batch of elements.

Arguments:

- `ignore ` (`string`): if given, `ignore` is taken to be the "negative" class and its statistics will be withheld
from the computation. Optional.

Returns:

- (`table, table, table`) micro, macro, and class scores

Example:

```lua
local s = Scorer()
s:add_pred('a', 'b', 1)
s:add_pred('b', 'b', 2)
s:add_pred('c', 'a', 3)
local micro, macro, all_stats = s:precision_recall_f1(ignore)
```

Returns the following

- `micro`: the micro averaged precision/recall/f1 statistics

- `macro`: the macro averaged precision/recall/f1 statistics

- `class_stats`: the precision/recall/f1 for each class

