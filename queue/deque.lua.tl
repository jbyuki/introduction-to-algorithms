##deque
@deque.lua=
@declare
@implement
@test

@declare+=
local deque = {}

@implement+=
function deque.new(cap)
  local o = {}
  o._tab = {}
  o._cap = cap
  for i=1,cap do table.insert(o._tab, 0) end
  o._head = 1
  o._tail = 1
  return setmetatable(o, {
    __index = deque
  })
end

function deque:push_back(x)
  self._tab[self._tail] = x

  self._tail = self._tail + 1
  if self._tail > self._cap then
    self._tail = 1
  end

  assert(self._tail ~= self._head, "overflow")
end

function deque:pop_front()
  assert(self._tail ~= self._head, "underflow")
  local elem = self._tab[self._head]

  self._head = self._head + 1
  if self._head > self._head then
    self._head = 1
  end

  return elem
end

function deque:push_front(x)
  self._head = self._head - 1
  if self._head < 1 then
    self._head = self._cap
  end

  self._tab[self._head] = x
end

function deque:pop_back()
  local elem

  self._tail = self._tail - 1
  if self._tail < 1 then
    self._tail = self._cap
  end

  return self._tab[self._tail]
end

@test+=
local dq = deque.new(30)
dq:push_back(30)
dq:push_back(20)
local x = dq:pop_back()
print(x)
local x = dq:pop_front()
print(x)
dq:push_front(10)
dq:push_front(5)
dq:push_front(2)
local x = dq:pop_back()
print(x)
