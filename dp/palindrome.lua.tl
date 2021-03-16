##palindrome
@palindrome.lua=
@declare
@implement
@create_data
@test

@declare+=
local find_longest_palindrome

@implement+=
function find_longest_palindrome(array)
  local best = {}
  @init_palindrome_of_zero_and_one


  @init_max_length
  for i=2,#array do
    best[i] = {}
    for j=1,#array-(i-1) do
      local local_best
      @palindrome_by_adjoing_one_to_left
      @palindrome_by_adjoing_one_to_right
      @palindrome_by_adjoing_left_and_right
      best[i][j] = local_best
    end
  end
  return best[#array][1]
end

@init_palindrome_of_zero_and_one+=
best[0] = {}
best[1] = {}

for i=1,#array do
  best[0][i] = {}
  best[1][i] = {array[i]}
end

@palindrome_by_adjoing_one_to_left+=
local_best = best[i-1][j+1]

@palindrome_by_adjoing_one_to_right+=
if #best[i-1][j] > #local_best then
  local_best = best[i-1][j]
end

@palindrome_by_adjoing_left_and_right+=
if j <= #array-(i-1) then
  if array[j] == array[j+(i-1)] then
    if #best[i-2][j+1]+2 > #local_best then
      local_best = { array[j] }
      for _, c in ipairs(best[i-2][j+1]) do
        table.insert(local_best, c)
      end
      table.insert(local_best, array[j])
    end
  end
end

@declare+=
function toCharArray(str)
  local arr = {}
  for i=1,string.len(str) do
    table.insert(arr, string.sub(str, i, i))
  end
  return arr
end

@test+=
local input = "abcdeca"
print("input: " .. input)
local best = find_longest_palindrome(toCharArray(input))
print("longest subsequence palindrome: " .. table.concat(best, ''))
print("longest subsequence palindrome length: " .. #best)
