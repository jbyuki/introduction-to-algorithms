##heap
@declare+=
local build_heap

@implement+=
function build_heap(A)
  for i=math.floor(#A/2),1,-1 do
    max_heapify(A, i)
  end
end

@test+=
local tab = {}
for i=1,5 do table.insert(tab, math.random(10)) end

build_heap(tab)
print(vim.inspect(tab))
