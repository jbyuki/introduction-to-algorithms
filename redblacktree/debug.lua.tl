##rbt
@implement+=
function rbtree:debug_print()
  local closed = {}
  @add_sentinel_node_into_closed
  local open = {}
  table.insert(open, self.root)
  while #open > 0 do
    local cur = open[#open]
    table.remove(open)
    local line = ""
    @print_node_info
    @print_node_children
    @print_node_parent
    print(line)
    @add_node_children_if_not_in_closed
  end
end

@print_node_info+=
local color
line = cur.key
if cur.color == BLACK then
  line = line .. " BLACK"
else
  line = line .. " RED"
end

@print_node_children+=
if cur.right == node.sentinel then
  line = line .. " ([right] NIL) "
else
  line = line .. " ([right] " .. cur.right.key .. ") "
end

if cur.left == node.sentinel then
  line = line .. " ([left] NIL) "
else
  line = line .. " ([left] " .. cur.left.key .. ") "
end

@print_node_parent+=
if cur.p == node.sentinel then
  line = line .. " ([parent] NIL) "
else
  line = line .. " ([parent] " .. cur.p.key .. ") "
end

@add_sentinel_node_into_closed+=
closed[node.sentinel] = true

@add_node_children_if_not_in_closed+=
if not closed[cur.right] then
  table.insert(open, cur.right)
  closed[cur.right] = true
end

if not closed[cur.left] then
  table.insert(open, cur.left)
  closed[cur.left] = true
end
