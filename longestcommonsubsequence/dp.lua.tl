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
  best[0] = {}
  for j=0,#B do
    best[0][j] = 0
  end

  for i=1,#A do
    best[i] = {}
    best[i][0] = 0
    for j=1,#B do
      if B[j] ~= A[i] then
        best[i][j] = math.max(best[i-1][j], best[i][j-1])
      else
        best[i][j] = 1+best[i-1][j-1]
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
print(lcs)
