Queue = torch.class('Queue', 'LinkedList')

function Queue:enqueue(val)
  self:add(val)
end

function Queue:dequeue()
  assert(self:size() > 0, 'cannot dequeue from empty queue')
  return self:remove(1)
end

torch.getmetatable('Queue').__tostring__ = Queue.toString
