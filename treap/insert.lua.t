##treap
@implement+=
function treap:insert(z)
  @insert_node_as_binary_search_tree
  @assign_random_priority_to_node
  @restablish_min_heap_by_rotation
end

@implement+=
function node:add_left(z)
  self.left = z
  if z then
    z.p = self
  end
end

function node:add_right(z)
  self.right = z
  if z then
    z.p = self
  end
end

@insert_node_as_binary_search_tree+=
local prev
local cur = self.root

while cur do
  prev = cur
  if z.key < cur.key then
    cur = cur.left
  else
    cur = cur.right
  end
end

if not prev then
  self.root = z
elseif z.key < prev.key then
  prev:add_left(z)
else
  prev:add_right(z)
end

@create_data+=
local tree = treap.new()

@assign_random_priority_to_node+=
z.priority = math.random(1,1000)

@implement+=
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
function treap:rotate_left(x)
  local y = x.right
  assert(y, "rotate left does not have right")

  @move_beta_rotate_left
  @replace_x_rotate_left
  @place_x_under_rotate_left
  @correct_root_rotate_left

  return y
end

@move_beta_rotate_left+=
local beta = y.left
x:add_right(beta)

@replace_x_rotate_left+=
y.p = x.p
if x.p and x.p.left == x then
  x.p.left = y
elseif x.p and x.p.right == x then
  x.p.right = y
end

@place_x_under_rotate_left+=
y:add_left(x)

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
function treap:rotate_right(y)
  local x = y.left
  assert(x, "rotate right does not have left")

  @move_beta_rotate_right
  @replace_y_rotate_right
  @place_y_under_rotate_right
  @correct_root_rotate_right

  return x
end

@move_beta_rotate_right+=
local beta = x.right
y:add_left(beta)

@replace_y_rotate_right+=
x.p = y.p
if y.p and y.p.left == y then
  y.p.left = x
elseif y.p and y.p.right == y then
  y.p.right = x
end

@place_y_under_rotate_right+=
x:add_right(y)

@correct_root_rotate_left+=
if self.root == x then
  self.root = y
end

@correct_root_rotate_right+=
if self.root == y then
  self.root = x
end

@restablish_min_heap_by_rotation+=
while z.p do
  if z.p.priority < z.priority then
    break
  end

  if z.p.left == z then
    z = self:rotate_right(z.p)
  else
    z = self:rotate_left(z.p)
  end
end

@test+=
for i=1,10 do
  local key = math.random(1,100)
  tree:insert(node.new(key))
end
tree:check_binary_search_property()
tree:check_heap_property()
print("OK!")
