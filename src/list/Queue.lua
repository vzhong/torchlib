--- @module Queue
-- Queue implementation.
-- This is a subclass of `List`.

local Queue, parent = torch.class('tl.Queue', 'tl.LinkedList')
function Queue:__init(values)
  parent:__init(values)
end

--- Adds a value to the stack.
-- @arg {any} val - value to add
-- @returns {Queue} modified stack
function Queue:enqueue(val)
  self:add(val)
  return self
end

--- Returns and removes the first value in the queue.
-- @returns {any} removed value
function Queue:dequeue()
  assert(self:size() > 0, 'cannot dequeue from empty queue')
  return self:remove(1)
end

return Queue
