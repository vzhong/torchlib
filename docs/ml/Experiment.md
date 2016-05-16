# Experiment
Experiment container that is backed up to a Postgres instance.

Example:

Suppose we have already made a postgres database called `myexp`.



```lua
local c = Experiment.new('myexp')
local run = c:create_run{dataset='foobar', lr=1.0, n_hid=10}
print(run:info())
run:submit_scores(1, {macro={f1=0.53, precision=0.52, recall=0.54}, micro={f1=0.10, precision=0.10, recall=0.10}})
run:submit_scores(2, {macro={f1=0.55, precision=0.55, recall=0.55}, micro={f1=0.10, precision=0.10, recall=0.10}})
print(run:scores())

run:submit_prediction(1, 'person', 'thing', {dataset='foobar'})
run:submit_prediction(2, 'person', 'person', {dataset='foobar'})
run:submit_prediction(3, 'person', 'thing', {dataset='foobar'})
run:submit_prediction(4, 'thing', 'thing', {dataset='foobar'})
print(run:predictions())
```

## Experiment:\_\_init(name, username, password, hostname, port)
[View source](http://github.com/vzhong/torchlib/blob/master/src//ml/Experiment.lua#L38)

Constructor.

Arguments:

- `name ` (`string`): name of the experiment.
- ` ` (`username`): username for postgres. Optional.
- ` ` (`hostname`): hostname for postgres. Optional.
- ` ` (`port`): port for postgres

It is assumed that a database with this name also exists and the user has permission to connect to it.
For more information on the parameters for postgres, see:

http://keplerproject.github.io/luasql/manual.html#postgres_extensions. Optional.


## Experiment:setup()
[View source](http://github.com/vzhong/torchlib/blob/master/src//ml/Experiment.lua#L61)

Creates relevant tables.


## Experiment:delete()
[View source](http://github.com/vzhong/torchlib/blob/master/src//ml/Experiment.lua#L90)

Drops tables for this experiment.


## Experiment:query(query, iterator)
[View source](http://github.com/vzhong/torchlib/blob/master/src//ml/Experiment.lua#L119)

Submits a query to the database and returns the result.

Arguments:

- `query ` (`string`): query to run.
- `iterator ` (`boolean`): whether to return the result as an iterator or as a table. Optional.

Returns:

- (`conditional`) if `true`, then an iterator will be returned. Otherwise, a table will be returned

If the result is not a number, then results will be returned. If the result is a number, then no result will
be returned.

If the query fails, then an error will be raised.

## Experiment:create\_run(opt)
[View source](http://github.com/vzhong/torchlib/blob/master/src//ml/Experiment.lua#L163)

Creates a new run for the experiment.

Arguments:

- `opt ` (`table[any:any]`): options for the run.

Returns:

- (`table`) a Run object

The Run object returned has the following functions:

- `run.id`: the id for this run

- `run:info()`: retrieves the row in the runs table.

- `run:scores()`: retrieves the scores in the scores table.

- `run:submit_scores(epoch, scores)`: submits scores.

- `run:predictions(example_id)`: retrieves the predictions.

- `run:submit_prediction(example_id, pred, gold, info)`: submits a single prediction.

These are merely convenience functions mapping to corresponding methods in `Experiment`.

They are convienient in the sense that one does not have to memorize the `id` of the Run to use them.

## Experiment:get\_run\_info(id)
[View source](http://github.com/vzhong/torchlib/blob/master/src//ml/Experiment.lua#L181)

Retrieves the options for the requested run.

Arguments:

- `id ` (`int`): ID of the run to retrieve.


## Experiment:submit\_scores(run\_id, epoch, scores)
[View source](http://github.com/vzhong/torchlib/blob/master/src//ml/Experiment.lua#L191)

Submits a score for the run.

Arguments:

- `run_id ` (`int`): ID of the run to submit scores for.
- `epoch ` (`int`): epoch of the score.
- `scores ` (`table[string:number]`): scores to submit.


## Experiment:get\_run\_scores(id)
[View source](http://github.com/vzhong/torchlib/blob/master/src//ml/Experiment.lua#L203)

Retrieves the scores for the requested run.

Arguments:

- `id ` (`int`): ID of the run to retrieve.


## Experiment:submit\_prediction(run\_id, example\_id, pred, gold, info)
[View source](http://github.com/vzhong/torchlib/blob/master/src//ml/Experiment.lua#L214)

Submits the prediction for a single example for a run.

Arguments:

- `run_id ` (`int`): ID for the run.
- `example_id ` (`int`): ID for the example.
- `pred ` (`any`): prediction.
- `gold ` (`any`): ground truth. Optional.
- `info ` (`table`): information for the run. Optional.


## Experiment:get\_predictions(run\_id, example\_id)
[View source](http://github.com/vzhong/torchlib/blob/master/src//ml/Experiment.lua#L237)

Retrieves the prediction a run.

Arguments:

- `run_id ` (`int`): ID for the run.
- `example_id ` (`int`): ID for the example. If this is given then only the prediction for this example is returned. Optional.


