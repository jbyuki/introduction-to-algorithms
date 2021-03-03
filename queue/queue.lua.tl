##queue
@queue.lua=
@declare
@implement
@test

@declare+=
local queue = {}

@implement+=
function queue.new(cap)
  local o = {}
  o._tab = {}
  o._cap = cap
  for i=1,cap do table.insert(o._tab, 0) end
  o._head = 1
  o._tail = 1
  return setmetatable(o, {
    __index = queue
  })
end

function queue:enqueue(x)
  self._tab[self._tail] = x

  self._tail = self._tail + 1
  if self._tail > self._cap then
    self._tail = 1
  end

  assert(self._tail ~= self._head, "overflow")
end

function queue:dequeue()
  assert(self._tail ~= self._head, "underflow")
  local elem = self._tab[self._head]

  self._head = self._head + 1
  if self._head > self._head then
    self._head = 1
  end

  return elem
end

@test+=
local q = queue.new(30)
print("push 10")
q:enqueue(10)
print("push 16")
q:enqueue(16)
print("push 20")
q:enqueue(20)
local x = q:dequeue()
print(x)
local x = q:dequeue()
print(x)
local x = q:dequeue()
print(x)
