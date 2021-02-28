##merge_sort
@merge_sort.lua=
@declare
@implement
@test

@declare+=
local merge_sort_helper, merge_sort, merge_sort_aux

@implement+=
function merge_sort(A)
  merge_sort_helper(A, 1, #A)
end

function merge_sort_helper(A, p, r)
  if r-p == 0 then return end
  @divide_and_conquer_merge
  @merge_whole
end

@divide_and_conquer_merge+=
local q = math.floor((p+r)/2)
merge_sort_helper(A, p, q)
merge_sort_helper(A, q+1, r)

@merge_whole+=
merge_sort_aux(A, p, q, r)

@implement+=
function merge_sort_aux(A, p, q, r)
  @create_merge_arrays
  @place_sentinel_cards_below
  @place_cards_into_output
end

@create_merge_arrays+=
local n1 = q - p + 1
local n2 = r - (q+1) + 1

local P = {}
local Q = {}

for i=0,n1-1 do
  table.insert(P, A[p+i])
end
for i=0,n2-1 do
  table.insert(Q, A[(q+1)+i])
end

@place_sentinel_cards_below+=
table.insert(P, math.huge)
table.insert(Q, math.huge)

@place_cards_into_output+=
local pi = 1
local qi = 1
for i=0,n1+n2-1 do
  if P[pi] < Q[qi] then
    A[p+i] = P[pi]
    pi = pi + 1
  else
    A[p+i] = Q[qi]
    qi = qi + 1
  end
end

@test+=
local tab = {}
for i=1,10 do
  table.insert(tab, math.random(100))
end
merge_sort(tab)
print(vim.inspect(tab))
