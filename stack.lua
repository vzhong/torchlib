local Stack = torch.class('Stack', 'LinkedList')

function Stack:push(val)
  self:add(val)
end

function Stack:pop()
  assert(self:size() > 0, 'cannot dequeue from empty queue')
  return self:remove(self:size())
end

torch.getmetatable('Stack').__tostring__ = Stack.toString
