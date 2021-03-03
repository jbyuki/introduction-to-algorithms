##stack
@stack.lua=
@declare
@implement
@test

@declare+=
local stack = {}

@implement+=
function stack.new()
  local o = {}
  o._tab = {}
  o._top = 0
  return setmetatable(o, {
    __index = stack,
  })
end

function stack:empty()
  return self._top == 0
end

function stack:push(x)
  self._top = self._top + 1
  self._tab[self._top] = x
end

function stack:pop(x)
  assert(self._top > 0, "underflow")
  self._top = self._top - 1
  return self._tab[self._top+1]
end

@test+=
local s = stack.new()
print("push 3")
s:push(3)
print("push 5")
s:push(5)
print("pop")
print(s:pop())
print("push 10")
s:push(10)
print("pop")
print(s:pop())
print("is empty: " .. vim.inspect(s:empty()))
print("pop")
print(s:pop())
print("is empty: " .. vim.inspect(s:empty()))
