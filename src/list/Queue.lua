--[[ A linkedlist based implementation of queue. ]]
local Queue, parent = torch.class('tl.Queue', 'tl.LinkedList')
function Queue:__init(values)
  parent:__init(values)
end

--[[ Adds a value onto the queue. ]]
function Queue:enqueue(val)
  self:add(val)
end

--[[ Removes the first element from the queue. ]]
function Queue:dequeue()
  assert(self:size() > 0, 'cannot dequeue from empty queue')
  return self:remove(1)
end

return Queue
