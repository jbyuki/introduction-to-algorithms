##linear
@linear.lua=
local M = {}
@implement
@test
return M

@o+=
local A

@implement+=
function M.find_maxsubarray(A)
  local smallest = math.huge
  local biggest = A[1]
  local sum = 0
  for i=1,#A do
    sum = sum + A[i]

    if sum > biggest then
      biggest = sum
    end

    if sum-smallest > biggest then
      biggest = sum-smallest
    end

    if i < #A and sum < smallest then
      smallest = sum
    end
  end

  if sum > biggest then
    biggest = sum
  end

  if sum-smallest > biggest then
    biggest = sum-smallest
  end

  return biggest
end

@test+=
local tab = {-1,-2,-3}
local sum = M.find_maxsubarray(tab)
