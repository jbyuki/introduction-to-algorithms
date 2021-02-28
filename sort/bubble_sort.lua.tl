##bubble_sort
@bubble_sort.lua=
@declare
@implement
@test

@declare+=
local bubble_sort

@implement+=
function bubble_sort(A)
  for i=1,#A do
    @spill_out_smallest_value
  end
end

@spill_out_smallest_value+=
for j=#A,i+1,-1 do
  if A[j] < A[j-1] then
    A[j], A[j-1] = A[j-1], A[j]
  end
end

@test+=
local tab = {}
for i=1,10 do
  table.insert(tab, math.random(100))
end
bubble_sort(tab)
print(vim.inspect(tab))
