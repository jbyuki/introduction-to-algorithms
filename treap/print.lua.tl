##treap
@implement+=
function treap:print()
  local closed = {}
  local open = {}
  if self.root then
    table.insert(open, self.root)
  end

  while #open > 0 do
    @extract_node_in_open
    @print_node_info
    @add_child_if_not_in_closed
  end
end

@extract_node_in_open+=
local cur = open[#open]
table.remove(open)

@print_node_info+=
local line = cur.key .. " [priority " .. (cur.priority or 0) .. "]"
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
  line = line .. " [parent " .. cur.p.key .. "]"
else
  line = line .. " [parent nil]"
end

print(line)

@add_child_if_not_in_closed+=
if cur.left and not closed[cur.left] then
  table.insert(open, cur.left)
  closed[cur.left] = true
end

if cur.right and not closed[cur.right] then
  table.insert(open, cur.right)
  closed[cur.right] = true
end
