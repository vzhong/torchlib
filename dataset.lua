local Split = torch.class('Split')

function Split:__init(X, Y, max_len)
  self.X = {}
  self.Y = {}
  for i = 1, #X do
    if max_len == nil or X[i]:size(1) <= max_len then
      table.insert(self.X, X[i])
      table.insert(self.Y, Y[i])
    end
  end
  self:reset()
end

function Split:reset()
  self:generateBatches()
  self.batch_id = 1
end

function Split:generateBatches()
  self.lengthMap = self:groupByLength()
  self.Xbatch, self.Ybatch = self:getBatches()
end

function Split:groupByLength()
  local lengthMap = HashMap.new()
  for i = 1, #self.X do
    local x = self.X[i]
    local len = x:size(1)
    if not lengthMap:contains(len) then
      lengthMap:add(len, {})
    end
    table.insert(lengthMap:get(len), i)
  end
  return lengthMap
end

function Split:shuffle()
  local indices = Util.range(self:size())
  Util.shuffle(indices)
  local X = {}
  local Y = {}
  for _, i in ipairs(indices) do
    table.insert(X, self.X[i])
    table.insert(Y, self.Y[i])
  end
  self.X = X
  self.Y = Y
  self:reset()
end

function Split:kfold(n_fold)
  local folds = {}
  for i = 1, n_fold do
    folds[i] = Set.new()
  end
  local selector = 1
  for i, x in ipairs(self.X) do
    folds[selector]:add(i)
    selector = selector + 1
    if selector > n_fold then
      selector = 1
    end
  end
  return folds
end

function Split:split_fold(test_fold)
  local Xtrain, Ytrain, Xtest, Ytest = {}, {}, {}, {}
  for i = 1, self:size() do
    if test_fold:contains(i) then
      table.insert(Xtest, self.X[i])
      table.insert(Ytest, self.Y[i])
    else
      table.insert(Xtrain, self.X[i])
      table.insert(Ytrain, self.Y[i])
    end
  end
  return Xtrain, Ytrain, Xtest, Ytest
end

function Split:size()
  return #self.X
end

function Split:getBatches()
  local lengths = self.lengthMap:keySet():toTable()
  local X = {}
  local Y = {}
  for i, length in ipairs(lengths) do
    local inds = torch.IntTensor(self.lengthMap:get(length))
    local Xbatch = torch.IntTensor(inds:size(1), length)
    local Ybatch = torch.IntTensor(inds:size(1))
    for j = 1, inds:size(1) do
      local ind = inds[j]
      local x = self.X[ind]
      local y = self.Y[ind]
      Xbatch[j] = x
      Ybatch[j] = y
    end
    table.insert(X, Xbatch)
    table.insert(Y, Ybatch)
  end
  return X, Y
end

function Split:step()
  self.batch_id = self.batch_id + 1
  if self.batch_id == #self.Xbatch then
    self.batch_id = 1
  end
end

function Split:getBatch()
  local x, y = self.Xbatch[self.batch_id], self.Ybatch[self.batch_id]
  self:step()
  return x, y
end

