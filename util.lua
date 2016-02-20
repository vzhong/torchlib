local Util = torch.class('Util')

function Util.printTable(t)
    function printTableHelper(t, spacing)
        for k,v in pairs(t) do
            print(spacing..tostring(k), v)
            if (type(v) == "table") then 
                printTableHelper(v, spacing.."\t")
            end
        end
    end
    printTableHelper(t, "");
end

function Util.range(from, to, inc)
  inc = inc or 1
  if to == nil then
    to = from
    from = 1
  end

  local t = {}
  for i = from, to, inc do
    table.insert(t, i)
  end
  return t
end 

function Util.shuffle(t)
  local iter = #t
  local j
  for i = iter, 2, -1 do
    j = math.random(i)
    t[i], t[j] = t[j], t[i] -- swap
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
  local d = {}
  for k, v in pairs(t1) do
    d[v] = true
  end
  for k, v in pairs(t2) do
    if d[v] ~= true then return false end
  end
  return true
end

function Util.reverseTable(t)
  local tab = {}
  for i, e in ipairs(t) do
    table.insert(tab, 1, e)
  end
  return tab
end

function Util.copyTable(t)
  local tab = {}
  for i, e in ipairs(t) do
    table.insert(tab, e)
  end
  return tab
end
