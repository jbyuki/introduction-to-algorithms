##counting_sort
@counting_sort=
@implement
@test

@implement+=
function counting_sort(A, k)
  @create_output_array
  @create_count_array
  @init_count_array_to_zero
  @count_number_of_elements_in_A
  @transform_to_accumulated_count
  @fill_output_array_with_accumulated_count
  return B
end

@create_output_array+=
local B = {}
for i=1,#A do table.insert(B, 0) end

@create_count_array+=
local C = {}

@init_count_array_to_zero+=
for i=0,k do
  C[i] = 0
end

@count_number_of_elements_in_A+=
for _, ai in ipairs(A) do
  C[ai] = C[ai] + 1
end

@transform_to_accumulated_count+=
for p,_ in pairs(C) do
  if p > 0 then
    C[p] = C[p] + C[p-1]
  end
end

@fill_output_array_with_accumulated_count+=
for _, ai in ipairs(A) do
  B[C[ai]] = ai
  C[ai] = C[ai] - 1
end

@test+=
local tab = {}
for i=1,10 do table.insert(tab, math.random(10)) end
local res = counting_sort(tab, 10)
print(vim.inspect(res))
