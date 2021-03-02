##benchmark
@benchmark.lua=
@requires
local a = 100
@time_values
for len=1,1000 do
  @push_table_length
  @generate_array_with_length_len
  @benchmark_with_brute_force
  @benchmark_with_divide_and_conquer
end
@print_out_benchmark_result_as_csv

@generate_array_with_length_len+=
local tab = {}
for i=1,len do
  table.insert(tab, math.random(100)-50)
end

@requires+=
local M = require"tangle.brute_force"

@benchmark_with_brute_force+=
M.find_maxsubarray(tab)

@benchmark_with_brute_force-=
local start = vim.fn.reltime()

@benchmark_with_brute_force+=
local elapsed = vim.fn.reltimefloat(vim.fn.reltime(start))
table.insert(brute_force_time, elapsed)

@time_values+=
local brute_force_time = {}

@requires+=
local divide_and_conquer = require"tangle.divide_and_conquer"

@benchmark_with_divide_and_conquer+=
divide_and_conquer.find_maxsubarray(tab, 1, #tab)

@benchmark_with_divide_and_conquer-=
local start = vim.fn.reltime()

@benchmark_with_divide_and_conquer+=
local elapsed = vim.fn.reltimefloat(vim.fn.reltime(start))
table.insert(divide_and_conquer_time, elapsed)

@time_values+=
local divide_and_conquer_time = {}
local tab_lengths = {}

@push_table_length+=
table.insert(tab_lengths, len)

@print_out_benchmark_result_as_csv+=
local out = io.open("result.csv", "w")
for i, len in ipairs(tab_lengths) do
  out:write(len .. "," .. brute_force_time[i] .. "," .. divide_and_conquer_time[i] .. ";\n")
end
out:close()
