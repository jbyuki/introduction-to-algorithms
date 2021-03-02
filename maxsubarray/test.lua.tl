##test
@test.lua=
@requires
@generate_test_data
@do_test

@requires+=
local brute_force = require"tangle.brute_force"
local divide_and_conquer = require"tangle.divide_and_conquer"

@generate_test_data+=
local tab = {}
for i=1,100 do
  table.insert(tab, math.random(100)-50)
end

@do_test+=
print(vim.inspect(tab))
print("best sum " .. brute_force.find_maxsubarray(tab))
local _, _, best_sum = divide_and_conquer.find_maxsubarray(tab, 1, #tab)
print("best sum d&c " .. best_sum)
