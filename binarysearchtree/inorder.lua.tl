##binary_search_tree
@binary_search_tree=
@declare
@implement
@test

@declare+=
local node = {}

@implement+=
function node.new(key)
  local o = { key = key }
  return setmetatable(o, {__index = node})
end

function node:inorder_print()
  if self.left then self.left:inorder_print() end
  print(self.key)
  if self.right then self.right:inorder_print() end
end

function node:add_left(child)
  self.left = child
  child.parent = self
end

function node:add_right(child)
  self.right = child
  child.parent = self
end

@test+=
local root = node.new(6)
root:add_left(node.new(5))
root:add_right(node.new(7))
root.left:add_left(node.new(2))
root.left:add_right(node.new(5))
root.right:add_right(node.new(8))

root:inorder_print()
