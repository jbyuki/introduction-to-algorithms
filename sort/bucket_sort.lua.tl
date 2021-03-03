##bucket_sort
@bucket_sort=
@declare
@implement
@test

@declare+=
local bucket_sort

@implement+=
function bucket_sort(A)
  @create_buckets
  @place_elements_in_bucket
  @sort_each_bucket_using_insertion_sort
  @concatenate_buckets_to_have_result
  return result
end

@create_buckets+=
local buckets = {}
for i=0,#A-1 do
  buckets[i] = {}
end

@place_elements_in_bucket+=
for _, ai in ipairs(A) do
  local i = math.floor(ai/#A)
  table.insert(buckets[i], ai)
end

@sort_each_bucket_using_insertion_sort+=
for _, b in pairs(buckets) do
  for i=1,#b do
    local x = b[i]
    local k = i
    for j=i,#b do
      if x > b[j] then
        x = b[j]
        k = j
      end
    end
    b[k], b[i] = b[i], b[k]
  end
end

@concatenate_buckets_to_have_result+=
local result = {}
for i=0,#A-1 do
  for _, bi in ipairs(buckets[i]) do
    table.insert(result, bi)
  end
end

@test+=
local success = 0
for _=1,100 do
  local tab = {}
  for i=1,10 do table.insert(tab, math.random(100)/100) end
  tab = bucket_sort(tab)
  @verify_the_array_is_sorted
  @if_sorted_increment_success
  @otherwise_print_out_result_not_sorted
end
print("success " .. success)

@verify_the_array_is_sorted+=
local sorted = true
for i=1,10 do
  if i > 1 then
    if tab[i-1] > tab[i] then
      sorted = false
      break
    end
  end
end

@if_sorted_increment_success+=
if sorted then
  success = success + 1

@otherwise_print_out_result_not_sorted+=
else
  print(vim.inspect(tab))
end
