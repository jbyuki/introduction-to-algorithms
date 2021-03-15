##avl
@implement+=
function node:inorder_print()
  if self.left then
    self.left:inorder_print()
  end
  print(self.h .. " " .. self.key)
  if self.right then
    self.right:inorder_print()
  end
end

function avl:print()
  local closed = {}
  local open = {}
  if not self.root then
    return
  end

  table.insert(open, self.root)
  while #open > 0 do
    @pop_from_open
    @print_node_info
    @add_children_to_open_if_not_in_closed
  end
end

@pop_from_open+=
local cur = open[#open]
table.remove(open)

@print_node_info+=
local line = cur.key .. " [h " .. cur.h .. "]"
if cur.left then
  line = line .. " [left " .. cur.left.key .. "]"
else
  line = line .. " [left nil]"
end

if cur.right then
  line = line .. " [right " .. cur.right.key .. "]"
else
  line = line .. " [right nil]"
end

if cur.p then
  line = line .. " [p " .. cur.p.key .. "]"
else
  line = line .. " [p nil]"
end

print(line)

@add_children_to_open_if_not_in_closed+=
if cur.left and not closed[cur.left] then
  table.insert(open, cur.left)
  closed[cur.left] = true
end

if cur.right and not closed[cur.right] then
  table.insert(open, cur.right)
  closed[cur.right] = true
end
