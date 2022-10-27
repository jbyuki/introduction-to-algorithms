@*=
@includes

@variables
@struct
@declare
@define

auto main() -> int
{
	@start_timer
	for(int i=0; i<1000; ++i) {
		@create_tree
		@insert_in_tree
		@delete_in_tree
		@destroy_tree
	}
	@test_tree
	@stop_timer
	@show_elapsed
	return 0;
}

@variables+=
constexpr int T = 20;

@struct+=
struct bnode
{
	bool leaf;
	int keys[2*T-1];
	bnode* children[2*T];
	int n;
};

struct btree
{
	bnode* root;
};

@define+=
btree* create_tree()
{
	btree* tree = new btree;
	tree->root = new bnode;
	tree->root->n = 0;
	tree->root->leaf = true;
	return tree;
}

@create_tree+=
btree* tree = create_tree();

@define+=
void destroy_tree(btree* tree)
{
	@delete_tree_recursively
	delete tree;
}

@destroy_tree+=
destroy_tree(tree);

@includes+=
#include <chrono>

@start_timer+=
auto start = std::chrono::high_resolution_clock::now();

@stop_timer+=
auto stop = std::chrono::high_resolution_clock::now();
std::chrono::duration<float> delta = stop - start;
float elapsed = (float)delta.count();

@includes+=
#include <iostream>

@show_elapsed+=
std::cout << "Elapsed: " << elapsed*1000.f << "ms" << std::endl;

@insert_in_tree+=
for(int j=1; j<=1000; ++j) 
{
	insert_tree(tree, j);
}

@declare+=
auto insert_tree(btree* tree, int value) -> void;

@define+=
auto insert_tree(btree* tree, int value) -> void
{
	if(tree->root->n == 2*T - 1) {
		@create_new_root
		@split_root_into_new_root
		@insert_non_full_new_root
	}

	@insert_non_full_root
}

@declare+=
auto insert_non_full(bnode* node, int value) -> void;

@define+=
auto insert_non_full(bnode* node, int value) -> void
{
	@get_last_key_index
	if(node->leaf) {
		@search_and_shift_where_key_can_fit
		@insert_key_in_leaf
	} else {
		@search_in_which_children_should_be_inserted
		@if_children_full_split
		@insert_non_full_in_children
	}
}

@declare+=
auto split_tree(bnode* parent, int i) -> void;

@define+=
auto split_tree(bnode* parent, int i) -> void
{
	@set_child_i_as_left_split
	@create_node_for_right_split

	@copy_half_keys_to_right_split
	@copy_half_children_to_right_split_if_internal

	@shift_children_in_parent
	@add_right_split_as_new_child
	@shift_keys_in_parent
	@add_median_key_as_new_key
}

@insert_non_full_root+=
insert_non_full(tree->root, value);

@get_last_key_index+=
int i = node->n-1;

@search_and_shift_where_key_can_fit+=
while(i >= 0 && value < node->keys[i]) {
	node->keys[i+1] = node->keys[i];
	i--;
}
i++;

@insert_key_in_leaf+=
node->keys[i] = value;
node->n++;

@search_in_which_children_should_be_inserted+=
//          [key 0]         [key 1]
// child 0          child 1         child 2
while(i >= 0 && value < node->keys[i]) {
	i--;
}
i++;

@if_children_full_split+=
if(node->children[i]->n == 2*T - 1) {
	split_tree(node, i);
	@adjust_if_should_insert_in_right_split
}

@adjust_if_should_insert_in_right_split+=
if(value > node->keys[i]) {
	++i;
}

@insert_non_full_in_children+=
insert_non_full(node->children[i], value);

@set_child_i_as_left_split+=
bnode* left_child = parent->children[i];

@create_node_for_right_split+=
bnode* right_child = new bnode;
right_child->leaf = left_child->leaf;

@copy_half_keys_to_right_split+=
for(int j=0; j<T-1; ++j) {
	right_child->keys[j] = left_child->keys[j+T];
}
right_child->n = T-1;
left_child->n = T-1;

@copy_half_children_to_right_split_if_internal+=
if(!left_child->leaf) {
	for(int j=0; j<T; ++j) {
		right_child->children[j] = left_child->children[j+T];
	}
}

@shift_children_in_parent+=
for(int j=parent->n; j>i; --j) {
	parent->children[j+1] = parent->children[j];
}

@add_right_split_as_new_child+=
parent->children[i+1] = right_child;

@shift_keys_in_parent+=
for(int j=parent->n-1; j>=i; --j) {
	parent->keys[j+1] = parent->keys[j];
}

@add_median_key_as_new_key+=
parent->keys[i] = left_child->keys[T-1];
parent->n++;

@create_new_root+=
bnode* new_root = new bnode;
new_root->leaf = false;
new_root->children[0] = tree->root;
new_root->n = 0;

@split_root_into_new_root+=
split_tree(new_root, 0);
tree->root = new_root;

@declare+=
auto destroy_node(bnode* node) -> void;

@define+=
auto destroy_node(bnode* node) -> void
{
	if(node->leaf) {
		delete node;
	} else {
		@delete_recursively_children_node
	}
}

@delete_recursively_children_node+=
for(int i=0; i<=node->n; ++i) {
	destroy_node(node->children[i]);
}
delete node;

@delete_tree_recursively+=
destroy_node(tree->root);

@define+=
auto delete_node_nonmin(btree* tree, bnode* node, int value) -> void
{
	@check_if_key_is_present

	@if_key_to_delete_in_leaf
	@if_key_to_delete_in_internal
	@if_key_is_not_found
}

@declare+=
auto delete_node_nonmin(btree* tree, bnode* node, int value) -> void;

@declare+=
auto delete_node(btree* tree, int value) -> void;

@define+=
auto delete_node(btree* tree, int value) -> void
{
	delete_node_nonmin(tree, tree->root, value);
}

@declare+=
auto search_node(bnode* node, int value, int* index) -> bnode*;

@define+=
auto search_node(bnode* node, int value, int* index) -> bnode*
{
	for(int i=0; i<node->n; ++i) {
		if(node->keys[i] == value) {
			*index = i;
			return node;
		} else if(node->keys[i] > value) {
			if(node->leaf) {
				return NULL;
			} else {
				return search_node(node->children[i], value, index);
			}
		}
	}
	if(node->leaf) {
		return NULL;
	} else {
		return search_node(node->children[node->n], value, index);
	}
}

@check_if_key_is_present+=
int i = 0;
while(i < node->n && node->keys[i] < value) {
	++i;
}

@if_key_to_delete_in_leaf+=
if(i < node->n && node->keys[i] == value) {
	if(node->leaf) {
		for(int j=i; j<node->n-1; ++j) {
			node->keys[j] = node->keys[j+1];
		}
		node->n--;
		return;
	}

@if_key_to_delete_in_internal+=
	else {
		@if_predecessor_child_has_T_keys_replace
		@if_successor_child_has_T_keys_replace
		@otherwise_merge_successor_and_predecessor_children
	}
}

@if_key_is_not_found+=
else {
	if(node->children[i]->n == T-1) {
		@if_left_sibling_can_lend_borrow
		@if_right_sibling_can_lend_borrow
		else {
			@otherwise_merge_with_left_sibling
			@otherwise_merge_with_right_sibling
			@if_only_child_decrease_height_and_recurse
		}
	}

	@recurse_on_child_to_remove_key
}

@declare+=
auto delete_node_nonmin_rightmost(bnode* node) -> int;

@define+=
auto delete_node_nonmin_rightmost(bnode* node) -> int
{
	@if_leaf_delete_rightmost
	@otherwise_recurse_for_rightmost_children
}

@if_leaf_delete_rightmost+=
if(node->leaf) {
	node->n--;
	return node->keys[node->n];
}

@otherwise_recurse_for_rightmost_children+=
else {
	int i = node->n;
	if(node->children[i]->n == T-1) {
		@if_left_sibling_can_lend_borrow
		@if_right_sibling_can_lend_borrow
		else {
			@otherwise_merge_with_left_sibling
			@otherwise_merge_with_right_sibling
		}
	}
	return delete_node_nonmin_rightmost(node->children[i]);
}

@if_predecessor_child_has_T_keys_replace+=
if(node->children[i]->n >= T) {
	int rightmost = delete_node_nonmin_rightmost(node->children[i]);
	node->keys[i] = rightmost;
	return;
}

@declare+=
auto delete_node_nonmin_leftmost(bnode* node) -> int;

@define+=
auto delete_node_nonmin_leftmost(bnode* node) -> int
{
	@if_leaf_delete_leftmost
	@otherwise_recurse_for_leftmost_children
}

@if_leaf_delete_leftmost+=
if(node->leaf) {
	int deleted = node->keys[0];
	for(int i=0; i<node->n-1; ++i) {
		node->keys[i] = node->keys[i+1];
	}
	node->n--;
	return deleted;
}

@otherwise_recurse_for_leftmost_children+=
else {
	int i = 0;
	if(node->children[i]->n == T-1) {
		@if_left_sibling_can_lend_borrow
		@if_right_sibling_can_lend_borrow
		else {
			@otherwise_merge_with_left_sibling
			@otherwise_merge_with_right_sibling
		}
	}
	return delete_node_nonmin_leftmost(node->children[i]);
}

@if_successor_child_has_T_keys_replace+=
if(node->children[i+1]->n >= T) {
	int leftmost = delete_node_nonmin_leftmost(node->children[i+1]);
	node->keys[i] = leftmost;
	return;
}

@otherwise_merge_successor_and_predecessor_children+=
bnode* left = node->children[i];
bnode* right = node->children[i+1];

@copy_keys_from_right_to_left_and_key_to_delete
@copy_children_from_right_to_left_if_needed

@remove_key_from_internal_node
@remove_child_from_internal_node

@decrease_tree_height_if_needed
@recurse_on_node_to_remove_key

@copy_keys_from_right_to_left_and_key_to_delete+=
for(int j=0; j<T-1; ++j) {
	left->keys[j+T] = right->keys[j];
}
left->keys[T-1] = node->keys[i];
left->n += T;

@copy_children_from_right_to_left_if_needed+=
for(int j=0; j<T; ++j) {
	left->children[j+T] = right->children[j];
}

@remove_key_from_internal_node+=
for(int j=i; j<node->n-1; ++j) {
	node->keys[j] = node->keys[j+1];
}

@remove_child_from_internal_node+=
for(int j=i+1; j<node->n; ++j) {
	node->children[j] = node->children[j+1];
}
node->n--;

@decrease_tree_height_if_needed+=
if(tree->root == node && node->n == 0) {
	tree->root = left;
	delete node;
}

@recurse_on_node_to_remove_key+=
delete_node_nonmin(tree, left, value);

@if_left_sibling_can_lend_borrow+=
if(i-1 >= 0 && node->children[i-1]->n >= T) {
	bnode* left = node->children[i-1];

	@add_new_key_to_children_i_from_left_and_parent
	
	node->keys[i-1] = left->keys[left->n-1];
	left->n--;
}

@add_new_key_to_children_i_from_left_and_parent+=
bnode* right = node->children[i];
for(int j=right->n; j>0; --j) {
	right->keys[j] = right->keys[j-1];
}

if(!right->leaf) {
	for(int j=right->n+1; j>0; --j) {
		right->children[j] = right->children[j-1];
	}
	right->children[0] = left->children[left->n];
}

right->keys[0] = node->keys[i-1];
right->n++;

@if_right_sibling_can_lend_borrow+=
else if(i+1 <= node->n && node->children[i+1]->n >= T) {
	bnode* right = node->children[i+1];

	@add_new_key_to_children_i_from_right_and_parent
	node->keys[i] = right->keys[0];
	@remove_key_and_child_from_right_borrowed
}

@add_new_key_to_children_i_from_right_and_parent+=
bnode* left = node->children[i];

left->keys[left->n] = node->keys[i];
if(!left->leaf) {
	left->children[left->n+1] = right->children[0];
}
left->n++;

@remove_key_and_child_from_right_borrowed+=
for(int j=0; j<right->n-1; ++j) {
	right->keys[j] = right->keys[j+1];
}

if(!right->leaf) {
	for(int j=0; j<right->n; ++j) {
		right->children[j] = right->children[j+1];
	}
}

right->n--;

@otherwise_merge_with_left_sibling+=
if(i-1 >= 0) {
	bnode* left = node->children[i-1];
	bnode* right = node->children[i];

	i = i-1;
	@copy_right_keys_and_children_to_left_and_parent_key
	@remove_right_child_from_parent

}

@otherwise_merge_with_right_sibling+=
else {
	bnode* left = node->children[i];
	bnode* right = node->children[i+1];

	@copy_right_keys_and_children_to_left_and_parent_key
	@remove_right_child_from_parent

}

@recurse_on_child_to_remove_key+=
delete_node_nonmin(tree, node->children[i], value);

@copy_right_keys_and_children_to_left_and_parent_key+=
left->keys[T-1] = node->keys[i];

for(int j=0; j<T-1; ++j) {
	left->keys[T+j] = right->keys[j];
}

if(!left->leaf) {
	for(int j=0; j<T; ++j) {
		left->children[T+j] = right->children[j];
	}
}
left->n += T;

@remove_right_child_from_parent+=
for(int j=i+1; j<node->n; ++j) {
	node->children[j] = node->children[j+1];
}

for(int j=i; j<node->n-1; ++j) {
	node->keys[j] = node->keys[j+1];
}

node->n--;
delete right;

@if_only_child_decrease_height_and_recurse+=
if(node->n == 0) {
	tree->root = node->children[0];
	delete node;
	delete_node_nonmin(tree, tree->root, value);
	return;
}

@define+=
auto print_tree(btree* tree) -> void
{
	print_node(tree->root, 0);
}

@declare+=
auto print_node(bnode* node, int indent) -> void;

@define+=
auto print_node(bnode* node, int indent) -> void
{
	for(int i=0; i<node->n; ++i) {
		if(!node->leaf) {
			print_node(node->children[i], indent+1);
		}

		for(int i=0; i<indent; ++i) {
			std::cout << " ";
		}
		std::cout << node->keys[i] << std::endl;
	}

	if(!node->leaf) {
		print_node(node->children[node->n], indent+1);
	}
}

@delete_in_tree+=
for(int i=1000; i>=1; --i) {
	delete_node(tree, i);
}
