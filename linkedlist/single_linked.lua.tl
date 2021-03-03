##linkedlist
@linkedlist.lua=
@declare
@implement
@test

@declare+=
local single_linked = {}

@implement+=
function single_linked.new()
  local o = {}
  o._head = nil
  return setmetatable(o, {
    __index = single_linked
  })
end

function single_linked:search(x)
  local p = self._head
  while p and p.val ~= x do
    p = p.next
  end
  return p
end

function single_linked:insert(x)
  local n = { val = x }
  n.next = self._head
  self._head = n
  return n
end

@test+=
local l = single_linked.new()
l:insert(3)
l:insert(6)
if l:search(6) then
  print("has 6")
else
  print("has not 6")
end
if l:search(4) then
  print("has 4")
else
  print("has not 4")
end

@implement+=
function single_linked:delete(x) 
  local p = self._head
  local pp = nil
  while p and p.val ~= x do
    pp = p
    p = p.next
  end
  
  assert(p, x .. " not found")
  
  if not pp then
    self._head = self._head.next
  else
    pp.next = p.next
  end
end

@test+=
l:delete(6)
if l:search(6) then
  print("has 6")
else
  print("has not 6")
end
if l:search(3) then
  print("has 3")
else
  print("has not 3")
end

l:delete(3)
if l:search(3) then
  print("has 3")
else
  print("has not 3")
end
