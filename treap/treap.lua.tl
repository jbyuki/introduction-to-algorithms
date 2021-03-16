##treap
@treap.lua=
@declare
@implement
@create_data
@test

@declare+=
local treap = {}
local node = {}

@implement+=
function treap.new()
  local o = {}
  o.root = nil
  return setmetatable(o, {
    __index = treap
  })
end

function node.new(key)
  local o = {}
  o.p = nil
  o.left = nil
  o.right = nil
  o.priority = nil
  o.key = key
  return setmetatable(o, {
    __index = node
  })
end
