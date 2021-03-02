##divide_and_conquer
@divide_and_conquer.lua=
local M = {}
@declare
@implement
@test
return M

@test+=
local vals = {}
for i=1,10 do
  table.insert(vals, math.random(100)-50)
end
print("array " .. vim.inspect(vals))
local low, high, best_sum = M.find_maxsubarray(vals, 1, #vals)
print("low " .. low)
print("high " .. high)
print("best sum " .. best_sum)

@implement+=
function M.find_maxsubarray(A, low, high)
  if low == high then
    return low, high, A[low]
  else
    local mid = math.floor((low+high)/2)
    local left_low, left_high, left_sum = M.find_maxsubarray(A, low, mid)
    local right_low, right_high, right_sum = M.find_maxsubarray(A, mid+1, high)
    local cross_low, cross_high, cross_sum = M.find_maxsubarray_cross(A, low, mid, high)
    @if_best_sum_in_left_return_it
    @if_best_sum_in_right_return_it
    @otherwise_its_across_the_midpoint
  end
end

@if_best_sum_in_left_return_it+=
if left_sum >= right_sum and left_sum >= cross_sum then
  return left_low, left_high, left_sum
end

@if_best_sum_in_right_return_it+=
if right_sum >= left_sum and right_sum >= cross_sum then
  return right_low, right_high, right_sum
end

@otherwise_its_across_the_midpoint+=
return cross_low, cross_high, cross_sum

@o+=
local a

@implement+=
function M.find_maxsubarray_cross(A, low, mid, high)
  local left_best = mid
  local left_sum = A[mid]
  @compute_best_sum_for_left_part
  local right_best = mid+1
  local right_sum = A[mid+1]
  @compute_best_sum_for_right_part
  @return_combined_for_best_crossed_sum
end

@compute_best_sum_for_left_part+=
local sum = 0
for i=mid,low,-1 do
  sum = sum + A[i]
  if sum > left_sum then
    left_best = i
    left_sum = sum
  end
end

@compute_best_sum_for_right_part+=
sum = 0
for i=mid+1,high do
  sum = sum + A[i]
  if sum > right_sum then
    right_best = i
    right_sum = sum
  end
end

@return_combined_for_best_crossed_sum+=
return left_best, right_best, left_sum+right_sum
