--[[ A linkedlist based implementation of queue. ]]
Queue = torch.class('Queue', 'LinkedList')

--[[ Adds a value onto the queue. ]]
function Queue:enqueue(val)
  self:add(val)
end

--[[ Removes the first element from the queue. ]]
function Queue:dequeue()
  assert(self:size() > 0, 'cannot dequeue from empty queue')
  return self:remove(1)
end

torch.getmetatable('Queue').__tostring__ = Queue.toString
