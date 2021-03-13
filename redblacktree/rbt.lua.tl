##rbt
@rbt.lua=
@declare
@implement
@create_data
@test

@declare+=
local rbtree = {}
local node = {}

local BLACK = 0
local RED = 1

@implement+=
function rbtree.new()
  local o = {}
  o.root = node.sentinel
  return setmetatable(o,
    { __index = rbtree })
end

function node.new(key)
  local o = {}
  o.key = key
  o.left = node.sentinel
  o.right = node.sentinel
  o.p = node.sentinel
  o.color = BLACK
  return setmetatable(o,
    { __index = node })
end

node.sentinel = node.new()

-- Initial:
--     x
--   /  \
--  α   y
--    /  \
--   β    γ
--
-- Final:
--       y
--     /  \
--    x   γ
--  /  \   
-- α    β
--
function rbtree:rotate_left(x)
  local y = x.right
  assert(y, "attempt to rotate left with nil")
  @replace_y_with_beta
  @put_x_in_y_left
  @if_x_was_root_replace
end

function node:add_left(x)
  if x then
    x.p = self
  end
  self.left = x
end

function node:add_right(x)
  if x then
    x.p = self
  end
  self.right = x
end

@replace_y_with_beta+=
local beta = y.left
x:add_right(beta)

@put_x_in_y_left+=
y.p = x.p
if x.p and x.p.left == x then
  x.p.left = y
elseif x.p and x.p.right == x then
  x.p.right = y
end
y:add_left(x)

@if_x_was_root_replace+=
if self.root == x then
  self.root = y
end

@implement+=
-- Initial:
--       y
--     /  \
--    x   γ
--  /  \   
-- α    β
--
-- Final:
--     x
--   /  \
--  α   y
--    /  \
--   β    γ
--
function rbtree:rotate_right(y)
  local x = y.left
  assert(x, "attempt to rotate right with nil")
  @replace_beta_with_y
  @put_y_in_x_right
  @if_y_was_root_replace
end

@replace_beta_with_y+=
local beta = x.right
y:add_left(beta)

@put_y_in_x_right+=
x.p = y.p
if y.p and y.p.left == y then
  y.p.left = x
elseif y.p and y.p.right == y then
  y.p.right = x
end
x:add_right(y)

@if_y_was_root_replace+=
if self.root == y then
  self.root = x
end

@implement+=
function node:inorder_print()
  if self.left then self.left:inorder_print() end
  print(self.key)
  if self.right then self.right:inorder_print() end
end

-- @create_data+=
local tree = rbtree.new()
-- tree.root = node.new(7)
-- tree.root:add_left(node.new(4))
-- tree.root.left:add_left(node.new(3))
-- tree.root.left.left:add_left(node.new(2))
-- tree.root.left:add_right(node.new(6))
-- tree.root:add_right(node.new(11))
-- tree.root.right:add_left(node.new(9))
-- tree.root.right:add_right(node.new(18))
-- tree.root.right.right:add_left(node.new(14))
-- tree.root.right.right:add_right(node.new(19))
-- tree.root.right.right.left:add_left(node.new(12))
-- tree.root.right.right.left:add_right(node.new(17))
-- tree.root.right.right.right:add_right(node.new(22))
-- tree.root.right.right.right.right:add_left(node.new(20))
-- 
-- @test+=
-- tree:rotate_right(tree.root.right)
-- tree.root:inorder_print()
