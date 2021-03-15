##avl
@avl.lua=
@declare
@implement
@create_data
@test

@declare+=
local avl = {}
local node = {}

@implement+=
function avl.new()
  local o = {}
  o.root = nil
  return setmetatable(o, {
    __index = avl
  })
end

function node.new(key)
  local o = {}
  o.key = key
  o.h = nil
  o.p = nil
  o.left = nil
  o.right = nil
  return setmetatable(o, {
    __index = node
  })
end
