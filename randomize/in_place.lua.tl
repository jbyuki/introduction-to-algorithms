##randomize
@randomize.lua=
@declare
@implement
@test

@declare+=
local randomize_in_place

@implement+=
function randomize_in_place(A)
  local n = #A
  for i=1,n do
    local j = math.random(i,n)
    A[i], A[j] = A[j], A[i]
  end
end

@test+=
local tab = {}
for i=1,10 do
  table.insert(tab, math.random(100))
end
print(vim.inspect(tab))
randomize_in_place(tab)
print(vim.inspect(tab))
