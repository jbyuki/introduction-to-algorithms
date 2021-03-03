##quicksort
@quicksort.lua=
@declare
@implement
@test

@declare+=
local quicksort, quicksort_helper

@implement+=
function quicksort(A)
  quicksort_helper(A, 1, #A)
end

@implement+=
function quicksort_helper(A, p, r)
  if p < r then
    @choose_pivot_point
    @paritition_array_with_pivot
    @recurse_on_lower_half
    @recurse_on_upper_half
  end
end

@choose_pivot_point+=
local x = A[r]

@paritition_array_with_pivot+=
local i = p
for j=p,r-1 do
  if A[j] < x then
    @put_in_lower_half
    @increment_lower_half_index
  end
end
@put_at_pivot_in_middle

@put_in_lower_half+=
A[i], A[j] = A[j], A[i]

@increment_lower_half_index+=
i = i + 1

@put_at_pivot_in_middle+=
A[r], A[i] = A[i], A[r]
local q = i

@recurse_on_lower_half+=
quicksort_helper(A, p, q-1)

@recurse_on_upper_half+=
quicksort_helper(A, q+1, r)

@test+=
local tab = {}
for i=1,10 do table.insert(tab, math.random(10)) end
quicksort(tab)
print(vim.inspect(tab))
