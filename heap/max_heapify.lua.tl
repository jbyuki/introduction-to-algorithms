##heap
@heap.lua=
@declare
@implement
@test

@declare+=
local max_heapify

@implement+=
function max_heapify(A, i, heap_size)
  @compute_left_right_index
  @check_if_left_is_larger_prioriting_left_over_right
  @check_if_right_is_larger_than_parent_and_left
  @if_not_parent_swap_with_child_and_recurse
end

@compute_left_right_index+=
local l = 2*i
local r = 2*i+1

@check_if_left_is_larger_prioriting_left_over_right+=
local largest = i
if l <= heap_size and A[l] > A[i] then
  largest = l
end

@check_if_right_is_larger_than_parent_and_left+=
if r <= heap_size and A[r] > A[largest] then
  largest = r
end

@if_not_parent_swap_with_child_and_recurse+=
if largest ~= i then
  A[i], A[largest] = A[largest], A[i]
  max_heapify(A, largest, heap_size)
end
