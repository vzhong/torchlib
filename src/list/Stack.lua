--[[ Implements a stack based on linked list. ]]
local Stack = torch.class('tl.Stack', 'tl.LinkedList')

--[[ Adds a value to the stack. ]]
function Stack:push(val)
  self:add(val)
end

--[[ Returns and removes the value at the top of the stack. ]]
function Stack:pop()
  assert(self:size() > 0, 'cannot dequeue from empty stack')
  return self:remove(self:size())
end

return Stack
