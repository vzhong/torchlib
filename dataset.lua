local Split = torch.class('Split')

function Split:__init(X, Y, mask)
  self.X = X
  self.Y = Y
  self.mask = mask
  self.max_len = self.X:size(2)
end

function Split.fromTable(X, Y, max_len)
  local total = 0
  for i, x in ipairs(X) do
    if x:size(1) <= max_len then
      total = total + 1
    end
  end
  local myX = torch.IntTensor(total, max_len)
  local myY = torch.IntTensor(total)
  local mask = torch.IntTensor(total, max_len):fill(0)

  local filled = 0
  for i, x in pairs(X) do
    if x:size(1) <= max_len then
      filled = filled + 1
      myX[{filled, {1, x:size(1)}}] = x
      mask[{filled, {1, x:size(1)}}]:fill(1)
      myY[filled] = Y[i]
    end
  end

  return Split.new(myX, myY, mask)
end

function Split:size()
  return self.X:size(1)
end

function Split:shuffle()
  local perm = torch.randperm(self:size()):long()
  self.X = self.X:index(1, perm)
  self.Y = self.Y:index(1, perm)
  self.mask = self.mask:index(1, perm)
  return perm
end

function Split:kfold(n_fold)
  local folds = torch.IntTensor(n_fold, 2)
  local fold_size = math.ceil(self:size() / n_fold)
  local start = 1
  for i = 1, n_fold do
    local finish = math.min(start + fold_size - 1, self:size())
    folds[i][1] = start
    folds[i][2] = finish
    start = finish + 1
  end
  return folds
end

function Split:splitFold(test_fold)
  local start = test_fold[1]
  local finish = test_fold[2]

  local test_indices = torch.range(start, finish):long()
  local train_indices
  if start == 1 then
    train_indices = torch.range(finish + 1, self:size()):long()
  elseif finish == self:size() then
    train_indices = torch.range(1, start - 1):long()
  else
    train_indices = torch.zeros(self:size() - test_indices:size(1)):long()
    train_indices[{{1, start - 1}}] = torch.range(1, start - 1)
    train_indices[{{start, train_indices:size(1)}}] = torch.range(finish + 1, self:size())
  end

  local train = Split.new(self.X:index(1, train_indices), self.Y:index(1, train_indices), self.mask:index(1, train_indices))
  local test = Split.new(self.X:index(1, test_indices), self.Y:index(1, test_indices), self.mask:index(1, test_indices))
  return train, test
end

