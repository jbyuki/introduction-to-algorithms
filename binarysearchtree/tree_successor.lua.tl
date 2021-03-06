##binary_search_tree
@implement+=
function node:successor()
  if self.right then
    return self.right:min()
  end

  local c = self
  local n = self.parent
  while n and n.right == n do
    c = n
    n = n.parent
  end
  return n
end

@test+=
local succ = root.left:successor()
print("successor of " .. root.left.key .. " is " .. succ.key)
local succ = root.right:successor()
print("successor of " .. root.right.key .. " is " .. succ.key)
