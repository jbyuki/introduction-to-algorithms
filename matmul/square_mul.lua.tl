##matmul
@matmul.lua=
@declare
@implement
@test

@declare+=
local square_mul

@implement+=
function square_mul(A, B)
  local C = {}
  local n = #A
  for i=1,n do
    local row = {}
    for j=1,n do
      local sum = 0
      for k=1,n do
        sum = sum + A[i][k]*B[k][j]
      end
      table.insert(row, sum)
    end
    table.insert(C, row)
  end
  return C
end

-- @test+=
-- local A = {
  -- {1, 0, 0},
  -- {0, 1, 0},
  -- {0, 0, 1}
-- }
-- 
-- local B = {
  -- {2, 1, 0},
  -- {4, 1, 8},
  -- {0, 2, 1}
-- }
-- 
-- local C = square_mul(A, B)
-- for _, row in ipairs(C) do
  -- print(vim.inspect(row))
-- end
