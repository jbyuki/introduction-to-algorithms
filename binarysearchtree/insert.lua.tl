##binary_search_tree
@implement+=
function node:insert(z)
  @find_node_to_insert_z_while_keeping_previous
  @insert_z_at_position
end

@find_node_to_insert_z_while_keeping_previous+=
local prev = nil
local cur = self
local isleft = nil

while cur do
  prev = cur
  if cur.key > z.key then 
    cur = cur.left
    isleft = true
  else
    cur = cur.right
    isleft = false
  end
end

@insert_z_at_position+=
if isleft then
  prev:add_left(z)
else
  prev:add_right(z)
end

@test+=
print("new in order")
local new_node = node.new(10)
root:insert(new_node)
new_node = node.new(3)
root:insert(new_node)
root:inorder_print()
