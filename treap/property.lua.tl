##treap
@implement+=
function treap:check_binary_search_property(z)
  if not z then
    z = self.root
  end

  if not z then
    return
  end

  if z.left then
    assert(z.left.key <= z.key, "Binary search property not verified!")
    self:check_binary_search_property(z.left)
  end

  if z.right then
    assert(z.right.key >= z.key, "Binary search property not verified!")
    self:check_binary_search_property(z.right)
  end
end

function treap:check_heap_property(z)
  if not z then
    z = self.root
  end

  if not z then
    return
  end

  if z.left then
    assert(z.left.priority >= z.priority, "Heap property not verified!")
    self:check_heap_property(z.left)
  end

  if z.right then
    assert(z.right.priority >= z.priority, "Heap property not verified!")
    self:check_heap_property(z.right)
  end
end
