##radix_sort
@radix_sort.lua=
@declare
@implement
@test

@declare+=
local radix_sort

@implement+=
function radix_sort(A, d)
  @create_result_bins
  for i=1,d do
    @create_bins
    @place_cards_into_correct_bin
    @put_into_result_bin
  end
  return result
end

@create_result_bins+=
local result = A

@create_bins+=
local bins = {}
for j=0,9 do
  bins[j] = {}
end

@place_cards_into_correct_bin+=
for _, ai in ipairs(result) do
  @extract_digit_at_ith_position
  @place_in_bin
end

@extract_digit_at_ith_position+=
local digit = math.floor(ai/(10^(i-1)))%10

@place_in_bin+=
table.insert(bins[digit], ai)

@put_into_result_bin+=
result = {}
for i=0,9 do
  for _, el in ipairs(bins[i]) do
    table.insert(result, el)
  end
end

@test+=
local tab = {}
for i=1,10 do
  table.insert(tab, math.random(50))
end
print(vim.inspect(tab))
tab = radix_sort(tab, 3)
print(vim.inspect(tab))
