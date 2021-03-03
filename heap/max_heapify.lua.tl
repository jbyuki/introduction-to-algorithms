##heap
@heap.lua=
@declare
@implement
@test

@declare+=
local max_heapify

@implement+=
function max_heapify(A, i)
  @compute_left_right_index
  @check_which_index_is_largest
  @if_not_parent_swap_with_child_and_recurse
end

@compute_left_right_index+=
local l = 2*i
local r = 2*i+1

@check_which_index_is_largest+=
local largest = i
if l <= #A and A[l] > A[largest] then
  largest = l
end

if r <= #A and A[r] > A[i] then
  largest = r
end

@if_not_parent_swap_with_child_and_recurse+=
if largest ~= i then
  A[i], A[largest] = A[largest], A[i]
  max_heapify(A, largest)
end
