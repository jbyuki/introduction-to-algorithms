##editdistance
@editdistance.lua=
@declare
@implement
@create_data
@test

@declare+=
local editdistance

-- operations
--
-- Copy: 
--    z[j] = x[i]
--    i += 1, j += 1
-- Replace:
--    z[j] = c
--    i += 1, j += 1
-- Delete:
--    i += 1
-- Insert:
--    z[j] = c
--    j += 1
-- Twiddle:
--    z[j] = x[i+1]
--    z[j+1] = x[i]
--    i += 2, j += 2
-- Kill:
--    i = m + 1

@implement+=
function editdistance(x, y, costs)
  local i = 1
  local j = 1
  local z = {}

end
