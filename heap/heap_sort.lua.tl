##heap
@declare+=
local heap_sort

@implement+=
function heap_sort(A)
  @build_heap_out_of_A
  local heap_size = #A
  for i=#A,2,-1 do
    @put_top_element_at_the_end
    @decrease_active_heap_size
    @reorder_heap
  end
end


@build_heap_out_of_A+=
build_heap(A)

@put_top_element_at_the_end+=
A[i], A[1] = A[1], A[i]

@decrease_active_heap_size+=
heap_size = heap_size - 1

@reorder_heap+=
max_heapify(A, 1, heap_size)

@test+=
local tab = {}
for i=1,10 do table.insert(tab, math.random(100)) end
print(vim.inspect(tab))
heap_sort(tab)
print(vim.inspect(tab))
