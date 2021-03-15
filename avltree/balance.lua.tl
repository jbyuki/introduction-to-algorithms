##avl
@implement+=
function node:add_left(y)
  self.left = y
  if y then
    y.p = self
  end
end

function node:add_right(y)
  self.right = y
  if y then
    y.p = self
  end
end

@implement+=
-- Initial:
--     x
--   /  \
--  α   y
--    /  \
--   β    γ
--
-- Final:
--       y
--     /  \
--    x   γ
--  /  \   
-- α    β
function avl:rotate_left(x)
  local y = x.right
  assert(y, "rotate left does not have right")

  @fix_parent_of_x_rotate_left

  y.p = x.p
  x:add_right(y.left)
  y:add_left(x)

  @correct_height_rotate_left

  if self.root == x then
    self.root = y
  end

  return y
end

@fix_parent_of_x_rotate_left+=
if x.p and x == x.p.left then
  x.p.left = y
elseif x.p and x == x.p.right then
  x.p.right = y
end

@implement+=
function node:update_height()
  self.h = 0
  if self.left then
    self.h = math.max(self.h, self.left.h+1)
  end

  if self.right then
    self.h = math.max(self.h, self.right.h+1)
  end
end

function avl:update_height(x)
  while x do
    x:update_height()
    x = x.p
  end
end

@correct_height_rotate_left+=
x:update_height()

@implement+=
-- Initial:
--       y
--     /  \
--    x   γ
--  /  \   
-- α    β
--
-- Final:
--     x
--   /  \
--  α   y
--    /  \
--   β    γ
function avl:rotate_right(y)
  local x = y.left
  assert(x, "rotate right does not have left")

  @fix_parent_of_y_rotate_right

  x.p = y.p
  y:add_left(x.right)
  x:add_right(y)

  @correct_height_rotate_right

  if self.root == y then
    self.root = x
  end

  return x
end

@fix_parent_of_y_rotate_right+=
if y.p and y.p.left == y then
  y.p.left = x
elseif y.p and y.p.right == y then
  y.p.right = x
end

@correct_height_rotate_right+=
y:update_height()

@implement+=
function avl:balance(x)
  local left_h
  if x.left then left_h = x.left.h
  else left_h = -1 end

  local right_h
  if x.right then right_h = x.right.h
  else right_h = -1 end

  if left_h - right_h == 2 then
    return self:rotate_right(x)
  elseif right_h - left_h == 2 then
    return self:rotate_left(x)
  end

  return x
end
