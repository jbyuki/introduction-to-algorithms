##avl
@implement+=
function avl:insert(z)
  @insert_normal_as_binary_search_tree
  @update_height_from_newly_insert_node
  @go_back_up_and_rebalance_if_necessary
end

@insert_normal_as_binary_search_tree+=
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

@update_height_from_newly_insert_node+=
self:update_height(z)

@go_back_up_and_rebalance_if_necessary+=
while z do
  z = self:balance(z)
  z = z.p
end

@create_data+=
local tree = avl.new()

@test+=
for i=1,20 do
  local key = math.random(1, 100)
  tree:insert(node.new(key))
end
tree:print()
tree.root:inorder_print()
