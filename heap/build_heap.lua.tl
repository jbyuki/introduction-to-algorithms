##heap
@declare+=
local build_heap

@implement+=
function build_heap(A)
  for i=math.floor(#A/2),1,-1 do
    max_heapify(A, i, #A)
  end
end
