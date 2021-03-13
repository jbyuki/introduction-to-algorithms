##rbt
@implement+=
-- Property 4 of Red-Black Tree
-- All red node must have black children
function rbtree:check_property4(z)
  if not z then
    z = self.root
    if not z then
      return
    end
  end

  if z.color == red then
    assert(z.right, "Red node does not have right child")
    assert(z.left, "Red node does not have left child")
    assert(z.right.color == BLACK, "Red node does not have black right child")
    assert(z.left.color == BLACK, "Red node does not have black left child")
  end

  if z ~= node.sentinel then
    self:check_property4(z.right)
    self:check_property4(z.left)
  end
end

-- Property 2 of Red-Black Tree
-- Root node is black
function rbtree:check_property2()
  if self.root then
    assert(self.root.color == BLACK, "Root node is not black")
  end
end

function rbtree:check_binary_search(nums, z)
  if not nums then
    nums = {}
  end

  if not z then
    z = self.root
  end

  if z == node.sentinel then
    return
  end

  self:check_binary_search(nums, z.left)
  table.insert(nums, z.key)
  self:check_binary_search(nums, z.right)

  if z == self.root then
    @check_that_number_are_sorted
  end
end

@check_that_number_are_sorted+=
for i=1,#nums-1 do
  assert(nums[i] < nums[i+1], "numbers are not sorted!")
end
