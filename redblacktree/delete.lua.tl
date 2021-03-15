##rbt
@implement+=
function rbtree:replace(u, v)
  if u.p == node.sentinel then
    self.root = v
  elseif u == u.p.left then
    u.p.left = v
  else
    u.p.right = v
  end
  v.p = u.p
end

function node:leftmost()
  local prev, cur = node.sentinel, self
  while cur ~= node.sentinel do
    prev = cur
    cur = cur.left
  end
  return prev
end

function rbtree:delete(z)
  local x
  @save_replaced_color
  if z.left == node.sentinel then
    @save_right_as_replaced
    @replace_with_right_subtree
  elseif z.right == node.sentinel then
    @save_left_as_replaced
    @replace_with_left_subtree
  else
    @get_leftmostnode_which_is_minimum
    @save_replaced_color_for_leftmost
    @save_leftmost_right_as_replaced
    @if_leftmost_is_not_direct_child_extract
    @put_leftmost_in_place_of_delete
  end
  @if_replaced_color_is_black_fixup
end

@implement+=
function node:add_right(z)
  self.right = z
  z.p = self
end

function node:add_left(z)
  self.left = z
  z.p = self
end

@replace_with_right_subtree+=
self:replace(z, z.right)

@replace_with_left_subtree+=
self:replace(z, z.left)

@get_leftmostnode_which_is_minimum+=
local leftmost = z.right:leftmost()


@if_leftmost_is_not_direct_child_extract+=
if leftmost.p ~= z then
  self:replace(leftmost, leftmost.right)
  leftmost:add_right(z.right)
else
  x.p = leftmost
end

@put_leftmost_in_place_of_delete+=
leftmost:add_left(z.left)
self:replace(z, leftmost)
leftmost.color = z.color

@save_right_as_replaced+=
x = z.right

@save_left_as_replaced+=
x = z.left

@save_leftmost_right_as_replaced+=
x = leftmost.right

@save_replaced_color+=
local replaced_color = z.color

@save_replaced_color_for_leftmost+=
replaced_color = leftmost.color

@if_replaced_color_is_black_fixup+=
if replaced_color == BLACK then
  while x ~= self.root and x.color == BLACK do
    if x == x.p.left then
      local sibling = x.p.right
      @sibling_is_red_and_parent_is_black_implied
      @sibling_is_black_and_sibling_children_are_black
      @sibling_is_black_and_only_one_child_is_black
    elseif x == x.p.right then
      local sibling = x.p.left
      @sibling_is_red_and_parent_is_black_implied_right
      @sibling_is_black_and_sibling_children_are_black_right
      @sibling_is_black_and_only_one_child_is_black_right
    end
  end
  @x_is_red_black_so_set_it_to_black
end

@sibling_is_red_and_parent_is_black_implied+=
if sibling.color == RED then
  @exchange_color_sibling_and_parent
end

@exchange_color_sibling_and_parent+=
sibling.color = BLACK
x.p.color = RED
self:rotate_left(x.p)
w = x.p.right

@sibling_is_black_and_sibling_children_are_black+=
if sibling.left.color == BLACK and sibling.right.color == BLACK then
  sibling.color = RED
  x = x.p

@x_is_red_black_so_set_it_to_black+=
x.color = BLACK

@sibling_is_black_and_only_one_child_is_black+=
else
  @sibling_right_child_is_black_and_left_child_is_red
  @sibling_left_child_is_black_and_right_child_is_red
end

@sibling_right_child_is_black_and_left_child_is_red+=
if sibling.right.color == BLACK then
  @exchange_color_with_sibling_left
  self:rotate_right(sibling)
  sibling = x.p.right
end

@exchange_color_with_sibling_left+=
sibling.color = RED
sibling.left.color = BLACK

@sibling_left_child_is_black_and_right_child_is_red+=
sibling.color = x.p.color
x.p.color = BLACK
sibling.right.color = BLACK
self:rotate_left(x.p)
x = self.root

@sibling_is_red_and_parent_is_black_implied_right+=
if sibling.color == RED then
  @exchange_color_sibling_and_parent_right
end

@exchange_color_sibling_and_parent_right+=
sibling.color = BLACK
x.p.color = RED
self:rotate_left(x.p)
w = x.p.left

@sibling_is_black_and_sibling_children_are_black_right+=
if sibling.left.color == BLACK and sibling.right.color == BLACK then
  sibling.color = RED
  x = x.p

@sibling_is_black_and_only_one_child_is_black_right+=
else
  @sibling_left_child_is_black_and_right_child_is_red_right
  @sibling_right_child_is_black_and_left_child_is_red_right
end

@sibling_left_child_is_black_and_right_child_is_red_right+=
if sibling.left.color == BLACK then
  @exchange_color_with_sibling_right
  self:rotate_left(sibling)
  sibling = x.p.left
end

@exchange_color_with_sibling_right+=
sibling.color = RED
sibling.right.color = BLACK

@sibling_right_child_is_black_and_left_child_is_red_right+=

sibling.color = x.p.color
x.p.color = BLACK
sibling.left.color = BLACK
self:rotate_right(x.p)
x = self.root

@test+=
local nodes = {}
for i=1,10 do
  local key = math.random(1, 100)
  local new_node = node.new(key)
  tree:insert(new_node)
  table.insert(nodes, new_node)
  tree:check_property2()
  tree:check_property4()
  tree:check_binary_search()
end

tree.root:inorder_print()

for i=10,1,-1 do
  tree:delete(nodes[i])
  tree:check_property2()
  tree:check_property4()
  tree:check_binary_search()
end
print("OK!")
