##heap
@declare+=
local priority_queue = {}

@implement+=
function priority_queue.new(tab)
  local o = {}
  o.heap = tab
  build_heap(o.heap)
  o.heap_size = #o.heap
  return setmetatable(o,
    { __index = priority_queue })
end

function priority_queue:heap_max()
  return self.heap[1]
end

function priority_queue:heap_extract_max()
  @copy_max_element
  @replace_with_rightmost_element_in_array
  @decrease_heap_size
  @reorder_heap_from_top
  @return_max_element
end

@copy_max_element+=
local max = self:heap_max()

@replace_with_rightmost_element_in_array+=
self.heap[1] = self.heap[self.heap_size]

@decrease_heap_size+=
self.heap_size = self.heap_size - 1

@reorder_heap_from_top+=
max_heapify(self.heap, 1, self.heap_size)

@return_max_element+=
return max

@o+=
local a

@implement+=
function priority_queue:heap_increase_key(i, key)
  @check_that_key_is_larger
  @replace_key_at_position
  @swap_parent_until_heap_is_satisfied
end

@check_that_key_is_larger+=
assert(key >= self.heap[i], "key must be equal or larger for increase key")

@replace_key_at_position+=
self.heap[i] = key

@swap_parent_until_heap_is_satisfied+=
local parent = math.floor(i/2)
while parent > 0 and self.heap[parent] < self.heap[i] do
  self.heap[parent], self.heap[i] = self.heap[i], self.heap[parent]
  i = parent
  parent = math.floor(i/2)
end

@test+=
local tab = {}
for i=1,10 do
  table.insert(tab, math.random(100))
end

print("priority queue " .. vim.inspect(tab))

local p = priority_queue.new(tab)
print("max element " .. p:heap_max())
print("extracting max element...")
p:heap_extract_max()
print("max element " .. p:heap_max())
print("extracting max element...")
p:heap_extract_max()
print("max element " .. p:heap_max())
print("extracting max element...")
p:heap_extract_max()
print("max element " .. p:heap_max())
local a = 3
print("current element " .. p.heap[a])
p:heap_increase_key(a, 200)
print("max element " .. p:heap_max())
print("extracting max element...")
p:heap_extract_max()
print("max element " .. p:heap_max())
print("insert 101")
p:heap_insert(101)
print("max element " .. p:heap_max())

@implement+=
function priority_queue:heap_insert(key)
  self.heap_size = self.heap_size + 1
  if self.heap_size > #self.heap then
    table.insert(self.heap, 0)
  end
  self.heap[self.heap_size] = -math.huge
  self:heap_increase_key(self.heap_size, key)
end
