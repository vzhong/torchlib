local Util = torch.class('Util')

function Util.printTable(t)
  for k, v in pairs(t) do
    print(k, v)
  end
end

function Util.equals(a, b)
  if torch.type(a) ~= torch.type(b) then return false end
  if a.equals ~= nil and b.equals ~= nil then
    return a:equals(b)
  end
  return a == b
end

function Util.tableValuesEqual(t1, t2)
  if #t1 ~= #t2 then return false end
  d = {}
  for k, v in pairs(t1) do
    d[v] = true
  end
  for k, v in pairs(t2) do
    if d[v] ~= true then return false end
  end
  return true
end
