##matmul
@test+=
local success = 0
for i=1,10 do
  @generate_test_matrix
  @multiply_matrix_with_bruteforce
  @multiply_matrix_with_recursive
  @compute_both_matrices_if_correct
end
print("Num success: " .. success)

@generate_test_matrix+=
local A, B = {}, {}
for i=1,4 do
  local rowA, rowB = {}, {}
  for j=1,4 do
    table.insert(rowA, math.random(10)-5)
    table.insert(rowB, math.random(10)-5)
  end
  table.insert(A, rowA)
  table.insert(B, rowB)
end

@multiply_matrix_with_bruteforce+=
local resC = square_mul(A, B)

@multiply_matrix_with_recursive+=
local resC2 = square_mul_rec(A, B)

@compute_both_matrices_if_correct+=
local notEqual = false
for i=1,4 do
  for j=1,4 do
    if resC[i][j] ~= resC2[i][j] then
      notEqual = true
    end
  end
end

if not notEqual then
  success = success + 1 
end
