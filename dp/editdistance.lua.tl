##editdistance
@editdistance.lua=
@declare
@implement
@create_data
@test

@declare+=
local editdistance

@declare+=
local COPY = 1
local REPLACE = 2
local DELETE = 3
local INSERT = 4
local TWIDDLE = 5
local KILL = 6

@implement+=
function editdistance(x, y, costs)
  local best = {}

  best[1] = {}
  best[1][1] = { score = 0, ops = {}}

  for i=1,#x+1 do
    best[i] = best[i] or {}
    for j=1,#y+1 do
      @look_for_copy
      @look_for_replace
      @look_for_delete
      @look_for_insert
      @look_for_twiddle
      @look_for_kill
    end
  end

  return best[#x+1][#y+1]
end


@look_for_copy+=
-- Copy: 
--    z[j] = x[i]
--    i += 1, j += 1
if i > 1 and j > 1 and x[i-1] == y[j-1] then
  if best[i-1][j-1] and (not best[i][j] or best[i-1][j-1].score + costs[COPY] < best[i][j].score) then
    best[i][j] = best[i][j] or {}
    best[i][j].score = ((best[i-1][j-1] and best[i-1][j-1].score) or 0) + costs[COPY]
    best[i][j].ops = vim.deepcopy(best[i-1][j-1].ops)
    table.insert(best[i][j].ops, { COPY })
  end
end

@look_for_replace+=
-- Replace:
--    z[j] = c
--    i += 1, j += 1
if i > 1 and j > 1 then
  if best[i-1][j-1] and (not best[i][j] or best[i-1][j-1].score + costs[REPLACE] < best[i][j].score) then
    best[i][j] = best[i][j] or {}
    best[i][j].score = best[i-1][j-1].score + costs[REPLACE]
    best[i][j].ops = vim.deepcopy(best[i-1][j-1].ops)
    table.insert(best[i][j].ops, { REPLACE, x[j-1] })
  end
end

@look_for_delete+=
-- Delete:
--    i += 1
if i > 1 then
  if best[i-1][j] and (not best[i][j] or best[i-1][j].score + costs[DELETE] < best[i][j].score) then
    best[i][j] = best[i][j] or {}
    best[i][j].score = best[i-1][j].score + costs[DELETE]
    best[i][j].ops = vim.deepcopy(best[i-1][j].ops)
    table.insert(best[i][j].ops, { DELETE, i })
  end
end

@look_for_insert+=
-- Insert:
--    z[j] = c
--    j += 1
if j > 1 then
  if best[i][j-1] and (not best[i][j] or best[i][j-1].score + costs[INSERT] < best[i][j].score) then
    best[i][j] = best[i][j] or {}
    best[i][j].score = best[i][j-1].score + costs[INSERT]
    best[i][j].ops = vim.deepcopy(best[i][j-1].ops)
    table.insert(best[i][j].ops, { INSERT, x[j-1] })
  end
end

@look_for_twiddle+=
-- Twiddle:
--    z[j] = x[i+1]
--    z[j+1] = x[i]
--    i += 2, j += 2
if i > 2 and j > 2 and x[i-2] == y[j-1] and x[i-1] == y[j-2] then
  if best[i-2][j-2] and (not best[i][j] or best[i-2][j-2].score + costs[TWIDDLE] < best[i][j].score) then
    best[i][j] = best[i][j] or {}
    best[i][j].score = ((best[i-2][j-2] and best[i-2][j-2].score) or 0) + costs[TWIDDLE]
    best[i][j].ops = vim.deepcopy(best[i-2][j-2].ops)
    table.insert(best[i][j].ops, { TWIDDLE, y[j-1], y[j-2] })
  end
end


@look_for_kill+=
-- Kill:
--    i = m + 1
if j == #y+1 and i == #x+1 then
  for pi=1,#x do
    if best[pi][j] then
      if best[pi][j] and (not best[i][j] or best[pi][j].score + costs[KILL] < best[i][j].score) then
        best[i][j] = best[i][j] or {}
        best[i][j].score = best[pi][j].score + costs[KILL]
        best[i][j].ops = vim.deepcopy(best[pi][j].ops)
        table.insert(best[i][j].ops, { KILL })
      end
    end
  end
end

@declare+=
local toCharArray

@implement+=
function toCharArray(str)
  local arr = {}
  for i=1,string.len(str) do
    table.insert(arr, string.sub(str, i, i))
  end
  return arr
end

@create_data+=
local start = toCharArray("algorithm")
local finish = toCharArray("altruistic")
local costs = {}

costs[COPY] = 1
costs[REPLACE] = 1
costs[DELETE] = 1
costs[INSERT] = 1
costs[TWIDDLE] = 1
costs[KILL] = 1

local res = editdistance(start, finish, costs)
print("score " .. res.score)
print_ops(res.ops)

@declare+=
local print_ops

local COPY = 1
local REPLACE = 2
local DELETE = 3
local INSERT = 4
local TWIDDLE = 5
local KILL = 6

@implement+=
function print_ops(ops)
  for _, op in ipairs(ops) do
    if op[1] == COPY then
      print("COPY " .. vim.inspect(op[2]))
    elseif op[1] == REPLACE then
      print("REPLACE " .. vim.inspect(op[2]))
    elseif op[1] == DELETE then
      print("DELETE " .. vim.inspect(op[2]))
    elseif op[1] == INSERT then
      print("INSERT " .. vim.inspect(op[2]))
    elseif op[1] == TWIDDLE then
      print("INSERT " ..vim.inspect(op[2] .. " " .. vim.inspect(op[3])))
    elseif op[1] == KILL then
      print("KILL")
    end
  end
end
