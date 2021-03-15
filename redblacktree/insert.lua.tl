##rbt
@implement+=
function rbtree:insert(z)
  @insert_as_if_normal_binary_search_tree
  @color_node_in_red
  @fix_rbtree
end

@insert_as_if_normal_binary_search_tree+=
local y = node.sentinel
x = self.root
while x ~= node.sentinel do
  y = x
  if z.key < x.key then
    x = x.left
  else
    x = x.right
  end
end

if y == node.sentinel then
  self.root = z
elseif z.key < y.key then
  y:add_left(z)
elseif z.key > y.key then
  y:add_right(z)
end

@color_node_in_red+=
z.color = RED

@fix_rbtree+=
while z.p.color == RED do
  if z.p == z.p.p.left then
    @if_on_left_side_of_grandparent
  else
    @if_on_right_side_of_grandparent
  end
end
self.root.color = BLACK

@if_on_left_side_of_grandparent+=
local y = z.p.p.right
if y.color == RED then
  z.p.color = BLACK
  y.color = BLACK
  z.p.p.color = RED
else
  if z == z.p.right then
    z = z.p
    self:rotate_left(z)
  end
  z.p.color = BLACK
  z.p.p.color = RED
  self:rotate_right(z.p.p)
end

@if_on_right_side_of_grandparent+=
local y = z.p.p.left
if y.color == RED then
  z.p.color = BLACK
  y.color = BLACK
  z.p.p.color = RED
else
  if z == z.p.left then
    z = z.p
    self:rotate_right(z)
  end
  z.p.color = BLACK
  z.p.p.color = RED
  self:rotate_left(z.p.p)
end

@test+=
-- for i=1,100 do
  -- local key = math.random(1, 100)
  -- tree:insert(node.new(key))
  -- tree:check_property2()
  -- tree:check_property4()
  -- tree:check_binary_search()
-- end
-- print("OK!")
