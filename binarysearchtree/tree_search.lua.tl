##binary_search_tree
@implement+=
function node:search(key)
  if self.key == key then
    return self
  elseif key < self.key and self.left then
    return self.left:search(key)
  elseif key > self.key and self.right then
    return self.right:search(key)
  end
end

@test+=
local node = root:search(2)
if node then
  print("Found 2!")
else
  print("2 not found!")
end

local node = root:search(10)
if node then
  print("Found 10!")
else
  print("10 not found!")
end

@implement+=
function node:iterative_search(key)
  local node = self
  while node do
    if key < node.key then
      node = node.left
    elseif key > node.key then
      node = node.right
    else
      return node
    end
  end
end

@test+=
local node = root:iterative_search(2)
if node then
  print("Found 2!")
else
  print("2 not found!")
end

local node = root:iterative_search(10)
if node then
  print("Found 10!")
else
  print("10 not found!")
end
