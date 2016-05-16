# Model
Implementation of model abstract class.

The idea of this class is to provide a standard interface for training/evaluating models and help avoid duplication of code.
It is set up in a modular fashion such that a model can overwrite key components of the training process (eg. the actual
implementation of the network via `get_net`, the criterion via `get_criterion`, how batches from the dataset are preprocessed
via `process_batch`).

Example:



```lua
local MyModel = torch.class('MyModel', 'tl.Model')

function MyModel:required_params()
  return {'d_in', 'd_hid'}
end

function MyModel:get_net()
  return nn.Sequential()
      :add(nn.Linear(self.opt.d_in, self.opt.d_hid))
      :add(nn.Tanh())
      :add(nn.Linear(self.opt.d_hid, 1))
end

function MyModel:get_criterion()
  return nn.MSECriterion()
end
```

## Model:\_\_init(opt)
[View source](http://github.com/vzhong/torchlib/blob/master/src//ml/Model.lua#L46)

Constructor.

Arguments:

- `opt ` (`table`): a key-value map of parameters for the model.

If you feel the need to have a more specific constructor, you should add to the 
implementation of the child class. In practice, it is often sufficient to overwrite
the functions `get_net`, `get_criterion`, and `initialize`.


## Model:initialize()
[View source](http://github.com/vzhong/torchlib/blob/master/src//ml/Model.lua#L61)

Initializes the model.

By default, uniformly initializes all parameters to between -0.08 and 0.08 and resets gradients to 0.

Returns:

- (`Model`) initialized model

## Model:required\_params()
[View source](http://github.com/vzhong/torchlib/blob/master/src//ml/Model.lua#L70)



Returns:

- (`table`) required arguments for the constructor

By default returns empty table. If a required argument is not met, then the constructor will abort with an error.

## Model:get\_net()
[View source](http://github.com/vzhong/torchlib/blob/master/src//ml/Model.lua#L77)



Returns:

- (`torch.Module`) implementation of the network.

Note: You must overwrite this function.

## Model:get\_criterion()
[View source](http://github.com/vzhong/torchlib/blob/master/src//ml/Model.lua#L84)



Returns:

- (`torch.Module`) implementation of the network.

By default returns `nn.CrossEntropyCriterion()`.

## Model:process\_batch(batch, pad)
[View source](http://github.com/vzhong/torchlib/blob/master/src//ml/Model.lua#L95)

Applies prepocessing to the batch object returned by `Dataset.batches`.

Arguments:

- `batch ` (`table[string:table]`): a map from `Dataset.batches`.
- `pad ` (`int`): what to use to pad variably lengthed examples in `batch.X`.

Returns:

- (`table[string:table]`) padded batch

By default, this pads the `X` field using `Dataset.pad` and converts the `Y` field to a `Tensor`.
You may want to do different things here, such as convert tensors to CUDA, pad a different field etc.

## Model:train(dataset, opt, optimize, optim\_opt)
[View source](http://github.com/vzhong/torchlib/blob/master/src//ml/Model.lua#L122)

Trains on a `Dataset` instance.

Arguments:

- `dataset ` (`Dataset`): dataset to train on.
- `opt ` (`table`): training options.
- `optimize ` (`optim.optimizer`): optimizer for training. Optional, Default: `optim.adam`.
- `optim_opt ` (`table`): optimizer options. Optional.

Returns:

- (`number`) average loss per example

`opt` specifies:

    - `batch_size`: the number of examples per batch to fetch from `dataset`. By default this is `128`.

    - `silent`: whether to prevent progress updates (eg. via a progress bar). By default this is `false`.

    - `pad`: The integer used for padding variable lengthed sequences. By default this is `0`.

 Example:

```lua
d = Dataset{X = X, Y = Y}
 loss = model:train(d, {silent=true, batch_size=10}, optim.adam, {learningRate=1e-3})
```

## Model:evaluate(dataset, opt)
[View source](http://github.com/vzhong/torchlib/blob/master/src//ml/Model.lua#L187)

Evaluates on a `Dataset` instance.

Arguments:

- `dataset ` (`Dataset`): dataset to evaluate on.
- `opt ` (`table`): evaluation options.

Returns:

- (`number, torch.Tensor, torch.Tensor, torch.Tensor, torch.Tensor`) evaluation results

`opt` specifies:

   - `batch_size`: the number of examples per batch to fetch from `dataset`. By default this is `128`.

   - `silent`: whether to prevent progress updates (eg. via a progress bar). By default this is `false`.

   - `pad`: The integer used for padding variable lengthed sequences. By default this is `0`.

Returns the following:

- `loss`: average loss per example

- `pred`: a `Tensor` contintaing the predictions made

- `targ`: a `Tensor` contintaing the ground truth

- `max_scores`: a `Tensor` contintaing the max scores for each prediction

- `raw_scores`: a `Tensor` contintaing the raw scores for each prediction

Example:

```lua
d = Dataset{X = X, Y = Y}
loss, pred, targ, max_scores, raw_scores = model:evaluate(d, {silent=true, batch_size=10})
```

## Model:fit(dataset, opt, callbacks, progress, optim, optim\_opt)
[View source](http://github.com/vzhong/torchlib/blob/master/src//ml/Model.lua#L271)

Trains and evaluates a model.

Arguments:

- `dataset ` (`table[string:Dataset]`): a map of datasets.
- `opt ` (`table`): training options. Optional.
- `callbacks ` (`table[string:function]`): a map of callback functions that are run after each epoch. Optional.
- `progress ` (`function`): returns whether this epoch is an improvement over the best results seen so far. Optional.
- `optim ` (`optim.optimizer`): optimizer for `train`. Optional, Default: `optim.adam`.
- `optim_opt ` (`table`): optimizer options for `train`. Optional.

Returns:

- (`table, table`) best evaluation results seen during training and the training history of all evaluation results.

`dataset` contains:

- `train`: the `Dataset` to train on.

- `dev`: the development `Dataset` to evaluate on. Used for early stopping

- `test`: the `Dataset` to test on. Optional. If specified, then will be evaluated on at the end of training.

`opt` contains:

- `batch_size`: the number of examples per batch to fetch from `dataset`. By default this is `128`.

- `silent`: whether to prevent progress updates (eg. via a progress bar). By default this is `false`.

- `patience`: the number of sub-optimal epochs to tolerate before early stopping. Default is `5`.

- `n_epoch`: the maximum number of epochs to train for. Default is `30`.

- `save`: where to save progress. If not specified then no saving will be done.

`callbacks` functions take the following arguments:

- `split`: the name of the split being run

- `res`: the evaluation results for the split

If a callback returns values, then the values will be stored in the evaluation results for that epoch

 and printed to stdout.

`progress` takes a function that takes as arguments:

- `curr`: the evaluation results for the current epoch

- `best`: the best evaluation result so far

and returns whether `curr` is better than `best`. By default, this compares the `loss` field.

```lua
d = {
  train=Dataset{X = Xtrain, Y = Ytrain}, 
  dev=Dataset{X = Xdev, Y = Ydev}, 
  test=Dataset{X = Xtest, Y = Ytest}, 
}
best_scores, train_hist = model:fit(d, {silent=true, batch_size=10})
```

