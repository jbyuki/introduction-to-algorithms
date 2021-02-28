##insertion_sort
@insertion_sort.lua=
@implement
@test

@implement+=
local function insertion_sort(a)
  local sorted = {}
  for _, ai in ipairs(a) do
    local pos = 1
    for j=1,#sorted do
      if ai < sorted[j] then
        break
      end
      pos = pos + 1
    end
    table.insert(sorted, pos, ai)
  end
  return sorted
end

@test+=
local tab = {}
for i=1,10 do
  table.insert(tab, math.random(100))
end
local sorted = insertion_sort(tab)
print(vim.inspect(sorted))

@implement+=
local function insertion_sort_in_place(a)
  for i=2,#a do
    local ai = a[i]
    local j=i-1
    while j > 0 do
      if a[j] < ai then break end
      a[j+1] = a[j]
      j = j - 1
    end
    a[j+1] = ai
  end
end

@test+=
local tab = {}
for i=1,10 do
  table.insert(tab, math.random(100))
end
insertion_sort_in_place(tab)
print(vim.inspect(tab))
