##test
@test.lua=
@requires
local success = 0
local num_test = 1000
for _=1,num_test do
  @generate_test_data
  @do_test
end
print("Result: " .. success .. "/" .. num_test)
-- @do_additional_test

@requires+=
local brute_force = require"tangle.brute_force"
local divide_and_conquer = require"tangle.divide_and_conquer"
local linear = require"tangle.linear"

@generate_test_data+=
local tab = {}
for i=1,math.random(100) do
  table.insert(tab, math.random(100)-50)
end

@do_test+=
local sum1 = brute_force.find_maxsubarray(tab)
local _, _, sum2 = divide_and_conquer.find_maxsubarray(tab, 1, #tab)
local sum3 = linear.find_maxsubarray(tab)
if sum1 == sum2 and sum2 == sum3 then
  success = success + 1
else
  print(vim.inspect(tab))
end

@do_additional_test+=
local tab = { 43, -19, 27, 34, -48, -1, 40, -38, -44, 48, 13, -43, 21, -40, -26, -26, -27, -28, 15, 13, 20, -43, -30, -7, 7, 35, 32, 41, -47, 48, 19, -35, -47, -26, -25, 5, 15, 1, -12, 40, -35, 8, -10, -32, 41, 35, 19, 29, 18, -42, -38, -34, 13, 10, -24, 18, -21, 18, -3, -35, -24, 20, 36, -26, -44, 2, -21, -44, -14, -19, -1, -33, -3, -26, -22, -24, 35, 24, -21, -39, 26, -32, 1, -39, 26, 48, 24, 44, -40, -17, -13, 46, 22, -30, -17, 6, 27, 8, -12, -38 }
local sum1 = brute_force.find_maxsubarray(tab)
local _, _, sum2 = divide_and_conquer.find_maxsubarray(tab, 1, #tab)
print(vim.inspect(tab))
print(sum1)
print(sum2)

