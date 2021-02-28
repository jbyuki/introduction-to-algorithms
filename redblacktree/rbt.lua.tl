##rbt
@rbt.lua=
@create_red_black_tree
@insert_fn
@search_fn
@test_insert
@test_search

@create_red_black_tree+=
local tree = {
  root = nil
}

@insert_fn+=
local function insert(tree, val)
  @create_new_red_node
  @if_root_is_nil_just_insert_as_root
end

@create_new_red_node+=
local node = {
  color = 1, -- 0 is black, 1 is red
  val = val,
}

@if_root_is_nil_just_insert_as_root+=
if not tree.root then
  tree.root = node
end
