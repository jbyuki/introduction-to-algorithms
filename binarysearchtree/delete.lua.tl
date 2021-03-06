##binary_search_tree
@implement+=
function node:delete(z)
  if not z.left and not z.right then
    @delete_from_parent
  elseif z.left and not z.right then
    @replace_left_node_with_itself
  elseif not z.left and z.right then
    @replace_right_node_with_itself
  else
    @find_success_node_in_right_subtree
  end
end
