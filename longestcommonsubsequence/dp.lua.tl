##lcs
@lcs.lua=
@declare
@implement
@create_data
@test

@declare+=
local find_lcs

@implement+=
function find_lcs(A, B)
  local best = {}
  local best_seq = {}
  best[0] = {}
  for j=0,#B do
    best[0][j] = {}
  end

  for i=1,#A do
    best[i] = {}
    best[i][0] = {}
    for j=1,#B do
      if B[j] ~= A[i] then
        if #best[i-1][j] > #best[i][j-1] then
          best[i][j] = best[i-1][j]
        else
          best[i][j] = best[i][j-1]
        end
      else
        best[i][j] = vim.deepcopy(best[i-1][j-1])
        vim.list_extend(best[i][j], {A[i]})
      end
    end
  end

  return best[#A][#B]
end

@create_data+=
local A = {"X", "M", "J", "Y", "A", "U", "Z"}
local B = {"M", "Z", "J", "A", "W", "X", "U"}

@test+=
local lcs = find_lcs(A, B)
print("lcs is " .. vim.inspect(lcs))
