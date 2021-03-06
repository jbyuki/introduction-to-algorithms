##binary_search_tree
@implement+=
function node:max()
  local node = self
  while node.right do
    node = node.right
  end
  return node
end

@test+=
local max_node = root:max()
print("maximum is " .. max_node.key)
