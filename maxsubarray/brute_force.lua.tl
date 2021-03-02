##brute_force
@brute_force.lua=
local M = {}
@declare
@implement
@test
return M

@o+=
local a 

@implement+=
function M.find_best(A)
  local best
  for i=1,#A do
    for j=i+1,#A do
      @check_if_is_best_buy
    end
  end
  return best
end

@check_if_is_best_buy+=
local cur = A[j] - A[i]
if not best or cur > best then
  best = cur
end

@test+=
local tab = {}
for i=1,10 do
  table.insert(tab, math.random(100)-50)
end
print("array " .. vim.inspect(tab))
print("best sum " .. M.find_maxsubarray(tab))

@implement+=
function M.find_maxsubarray(A)
  local sum_best = A[1]
  for i=1,#A do
    local sum = 0
    for j=i,#A do
      sum = sum + A[j]
      sum_best = math.max(sum_best, sum)
    end
  end
  return sum_best
end
