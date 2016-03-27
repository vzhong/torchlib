local Table = require('torchlib').ProbTable

local TestTable = torch.TestSuite()
local tester = torch.Tester()

local t1 = function()
  return Table.new(torch.Tensor{{0.2, 0.8}, {0.4, 0.6}, {0.1, 0.9}}, {'a', 'b'})
end

local t2 = function()
  return Table.new(torch.Tensor{0.3, 0.7}, 'b')
end

local t3 = function()
  return Table.new(torch.Tensor{0.1, 0.2}, 'c')
end

function TestTable.test_init()
  local t = t1()
  tester:assertTableEq({'a', 'b'}, t.names)
  tester:assertTableEq({a=1, b=2}, t.name2index)
  tester:assertTensorEq(torch.Tensor{{0.2, 0.8}, {0.4, 0.6}, {0.1, 0.9}}, t.P)
end

function TestTable.test_clone()
  local t = t1()
  local tt = t:clone()
  tester:assertTableEq(t.names, tt.names)
  tester:assertTableEq(t.name2index, tt.name2index)
  tester:assertTensorEq(t.P, tt.P, 1e-5)
end

function TestTable.test_query()
  local t = t1()
  tester:assertTensorEq(torch.Tensor{0.2, 0.8}, t:query{a=1})
  tester:assertTensorEq(torch.Tensor{0.1, 0.9}, t:query{a=3})
  tester:assertTensorEq(torch.Tensor{0.8, 0.6, 0.9}, t:query{b=2})
  tester:asserteq(0.8, t:query{a=1, b=2})
  tester:asserteq(0.4, t:query{a=2, b=1})
  tester:asserteq(0.1, t:query{a=3, b=1})
end

function TestTable.test_mul_subset()
  local t = t1():mul(t2())
  tester:assertTableEq({'b', 'a'}, t.names)
  tester:assertTableEq({b=1, a=2}, t.name2index)
  tester:assertTensorEq(torch.Tensor{{0.06, 0.12, 0.03}, {0.56, 0.42, 0.63}}, t.P, 1e-5)
end

function TestTable.test_mul_extra()
  local t = t1():mul(t3())
  tester:assertTableEq({'c', 'a', 'b'}, t.names)
  tester:assertTableEq({c=1, a=2, b=3}, t.name2index)
  tester:assertTensorEq(torch.Tensor{
    {
      {0.02, 0.08}, {0.04, 0.06}, {0.01, 0.09},
    },
    {
      {0.04, 0.16}, {0.08, 0.12}, {0.02, 0.18},
    }
  }, t.P, 1e-5)
end

function TestTable.test_mul_overlap()
  local t = t2():mul(t1())
  tester:assertTableEq({'a', 'b'}, t.names)
  tester:assertTableEq({a=1, b=2}, t.name2index)
  tester:assertTensorEq(torch.Tensor{{0.06, 0.56}, {0.12, 0.42}, {0.03, 0.63}}, t.P, 1e-5)
end

function TestTable.test_mul1()
  local t = Table(torch.Tensor{2, 2, 2}, 'a')
  local tt = Table(torch.Tensor{{0.2, 0.8}, {0.4, 0.6}, {0.1, 0.9}}, {'a', 'b'})
  local r = t:mul(tt)
  tester:assertTableEq({'a', 'b'}, r.names)
  tester:assertTableEq({a=1, b=2}, r.name2index)
  tester:assertTensorEq(torch.Tensor{{0.4, 1.6}, {0.8, 1.2}, {0.2, 1.8}}, r.P, 1e-5)
end

function TestTable.test_marginalize()
  local t = t1():marginalize('a')
  tester:assertTableEq({'b'}, t.names)
  tester:assertTableEq({b=1}, t.name2index)
  tester:assertTensorEq(torch.Tensor{0.7, 2.3}, t.P, 1e-5)
  t = t1():marginalize('b')
  tester:assertTableEq({'a'}, t.names)
  tester:assertTableEq({a=1}, t.name2index)
  tester:assertTensorEq(torch.Tensor{1, 1, 1}, t.P, 1e-5)
end

function TestTable:test_marginal()
  local t = t1():marginal('b')
  tester:assertTableEq({'b'}, t.names)
  tester:assertTableEq({b=1}, t.name2index)
  tester:assertTensorEq(torch.Tensor{0.7, 2.3}, t.P, 1e-5)
  t = t1():marginal('a')
  tester:assertTableEq({'a'}, t.names)
  tester:assertTableEq({a=1}, t.name2index)
  tester:assertTensorEq(torch.Tensor{1, 1, 1}, t.P, 1e-5)
end

function TestTable.test_normalize()
  local t = t1():normalize()
  tester:assertTableEq({'a', 'b'}, t.names)
  tester:assertTableEq({a=1, b=2}, t.name2index)
  tester:assertTensorEq(torch.Tensor{{0.2/3, 0.8/3}, {0.4/3, 0.6/3}, {0.1/3, 0.9/3}}, t.P, 1e-5)
end

tester:add(TestTable)
tester:run()
