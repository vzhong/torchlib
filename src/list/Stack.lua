--- @module Stack
-- Stack implementation.
-- This is a subclass of `List`.

local Stack = torch.class('tl.Stack', 'tl.LinkedList')

--- Adds a value to the stack.
-- @arg {any} val - value to add
-- @returns {Stack} modified stack
function Stack:push(val)
  self:add(val)
  return self
end

--- Returns and removes the value at the top of the stack.
-- @returns {any} removed value
function Stack:pop()
  assert(self:size() > 0, 'cannot dequeue from empty stack')
  return self:remove(self:size())
end

return Stack
