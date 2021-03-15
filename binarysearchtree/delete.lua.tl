##binary_search_tree
@implement+=
function node:delete()
  if not self.left then
    @replace_with_right_subtree
  elseif not self.right then
    @replace_with_left_subtree
  else
    @find_minimum_in_right_subtree
    if min.parent ~= self then
      @put_minimum_at_top_of_subtree
    end
    @replace_top_subtree
  end
end

function node:replace(v)
  if self.parent then
    if self.parent.left == self then
      self.parent.left = v
    elseif self.parent.right == self then
      self.parent.right = v
    end
    if v then
      v.parent = self.parent
    end
  end

  return v
end

@replace_with_right_subtree+=
self:replace(self.right)

@replace_with_left_subtree+=
self:replace(self.left)

@find_minimum_in_right_subtree+=
local min = self.right:min()

@put_minimum_at_top_of_subtree+=
if min.right then
  min:replace(min.right)
end
min:add_right(self.right)

@replace_top_subtree+=
min:add_left(self.left)
self:replace(min)

@test+=
local node = root:search(5)
if node.left then
  print("has left")
end

if node.right then
  print("has right")
end

if not node.right and not node.left then
  print("has no right, no left")
end

print("delete " .. node.key)
node:delete()
