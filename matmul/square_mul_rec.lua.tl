##matmul
@declare+=
local square_mul_rec, square_mul_rec_helper

@implement+=
function square_mul_rec(A, B)
  local C = {}
  @compute_A_B_dimensions
  @init_C_matrix
  square_mul(A, B, C, {1, n}, {1, n}, {1, n}, {1, n}, {1, n}, {1, n})
  return C
end

@compute_A_B_dimensions+=
local n = #A

@init_C_matrix+=
local C = {}
for i=1,n do
  local row = {}
  for j=1,n do
    table.insert(row, 0)
  end
  table.insert(C, row)

end
square_mul_rec_helper(A, B, C, 
{1, n}, {1, n}, 
{1, n}, {1, n}, 
{1, n}, {1, n})

@implement+=
function square_mul_rec_helper(A, B, C, a_row, a_col, b_row, b_col, c_row, c_col)
  local n = a_row[2]-a_row[1]
  if n == 0 then
    C[c_row[1]][c_col[1]] = C[c_row[1]][c_col[1]] + A[a_row[1]][a_col[1]]*B[b_row[1]][b_col[1]]
  else
    @compute_partition_indices
    @compute_submatrix_multiplication
  end
end

@compute_partition_indices+=
local au_row = { a_row[1], math.floor((a_row[2]+a_row[1])/2) }
local ad_row = { math.floor((a_row[2]+a_row[1])/2)+1, a_row[2] }

local al_col = { a_col[1], math.floor((a_col[2]+a_col[1])/2) }
local ar_col = { math.floor((a_col[2]+a_col[1])/2)+1, a_col[2] }

local bu_row = { b_row[1], math.floor((b_row[2]+b_row[1])/2) }
local bd_row = { math.floor((b_row[2]+b_row[1])/2)+1, b_row[2] }

local bl_col = { b_col[1], math.floor((b_col[2]+b_col[1])/2) }
local br_col = { math.floor((b_col[2]+b_col[1])/2)+1, b_col[2] }

local cu_row = { c_row[1], math.floor((c_row[2]+c_row[1])/2) }
local cd_row = { math.floor((c_row[2]+c_row[1])/2)+1, c_row[2] }

local cl_col = { c_col[1], math.floor((c_col[2]+c_col[1])/2) }
local cr_col = { math.floor((c_col[2]+c_col[1])/2)+1, c_col[2] }

@compute_submatrix_multiplication+=
-- C11 = A11 * B11 + A12 * B21
square_mul_rec_helper(A, B, C, au_row, al_col, bu_row, bl_col, cu_row, cl_col)
square_mul_rec_helper(A, B, C, au_row, ar_col, bd_row, bl_col, cu_row, cl_col)

-- C12 = A11 * B12 + A12 * B22
square_mul_rec_helper(A, B, C, au_row, al_col, bu_row, br_col, cu_row, cr_col)
square_mul_rec_helper(A, B, C, au_row, ar_col, bd_row, br_col, cu_row, cr_col)

-- C21 = A21 * B11 + A22 * B21
square_mul_rec_helper(A, B, C, ad_row, al_col, bu_row, bl_col, cd_row, cl_col)
square_mul_rec_helper(A, B, C, ad_row, ar_col, bd_row, bl_col, cd_row, cl_col)

-- C22 = A21 * B12 + A22 * B22
square_mul_rec_helper(A, B, C, ad_row, al_col, bu_row, br_col, cd_row, cr_col)
square_mul_rec_helper(A, B, C, ad_row, ar_col, bd_row, br_col, cd_row, cr_col)

-- @test+=
-- local A = {
  -- { 1, 0 },
  -- { 0, 1 },
-- }
-- 
-- local B = {
  -- { 3, 3 },
  -- { 3, 3 },
-- }
-- 
-- local C = square_mul_rec(A, B)
-- for _, row in ipairs(C) do
  -- print(vim.inspect(row))
-- end
