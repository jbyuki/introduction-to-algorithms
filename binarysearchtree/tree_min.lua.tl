##binary_search_tree
@implement+=
function node:min()
  local node = self
  while node.left do
    node = node.left
  end
  return node
end

@test+=
local min_node = root:min()
print("minimum is " .. min_node.key)
