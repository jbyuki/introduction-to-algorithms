@*=
@includes

@variables
@struct
@declare
@define

auto main() -> int
{
	@start_timer
	// for(int i=0; i<1000; ++i) {
	@create_tree
	@test_tree
	// @print_tree
	@destroy_tree
	// }
	@stop_timer
	@show_elapsed
	return 0;
}

@variables+=
constexpr int T = 2;

@struct+=
struct bpnode
{
	bool leaf;
	bpnode* children[2*T];
	bpnode* parent;
	int n;

	union {
		int counts[2*T];
		int keys[2*T];
	};
};

struct bptree
{
	bpnode* root;
	int total;
};

@create_tree+=
bptree* tree = create_tree();

@define+=
auto create_tree() -> bptree*
{
	bptree* tree = new bptree;
	tree->total = 0;
	tree->root = new bpnode;
	tree->root->leaf = true;
	tree->root->n = 0;
	tree->root->parent = NULL;
	return tree;
}

@destroy_tree+=
destroy_tree(tree);

@define+=
auto destroy_tree(bptree* tree) -> void
{
	@delete_tree_recursively
	delete tree;
}

@declare+=
auto destroy_node(bpnode* node) -> void;

@define+=
auto destroy_node(bpnode* node) -> void
{
	if(!node->leaf) {
		for(int i=0; i<node->n; ++i) {
			destroy_node(node->children[i]);
		}
	}
	delete node;
}

@delete_tree_recursively+=
destroy_node(tree->root);

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
std::cout << "Elapsed: " << elapsed*1000.f << std::endl;


@define+=
auto tree_insert(bptree* tree, int index, int value) -> void
{
	if(tree->root->n == 2*T) {
		@create_new_root
		@split_root
	}
	node_insert_nonfull(tree, tree->root, index, value);
	tree->total++;
}

@declare+=
auto node_insert_nonfull(bptree* tree, bpnode* node, int index, int value) -> void;

@define+=
auto node_insert_nonfull(bptree* tree, bpnode* node, int index, int value) -> void
{
	if(node->leaf) {
		@insert_at_i
	} else {
		@search_for_children_node_to_insert
		if(node->children[j]->n == 2*T) {
			@split_current_node
		}
		@increase_counts_in_child
		@recurse_on_children_insert
	}
}

@insert_at_i+=
for(int j=node->n; j>index; --j) {
	node->keys[j] = node->keys[j-1];
}
node->keys[index] = value;
node->n++;

@search_for_children_node_to_insert+=
int j=0;
while(index >= node->counts[j] && j < node->n-1) {
	index -= node->counts[j];
	j++;
}
assert(index <= node->counts[j]);

@declare+=
auto node_split(bpnode* child, int j, bpnode** pright=NULL) -> void;

@define+=
auto node_split(bpnode* child, int j, bpnode** pright) -> void
{
	@create_right_sibling
	int right_count;
	@copy_keys_if_leaf
	@copy_children_and_counts_if_not

	@insert_right_as_child_in_parent
}

@includes+=
#include <cassert>

@create_right_sibling+=
bpnode* right = new bpnode;
right->n = 0;
right->parent = child->parent;
right->leaf = child->leaf;

@copy_keys_if_leaf+=
if(child->leaf) {
	for(int i=0; i<T; ++i) {
		right->keys[i] = child->keys[i+T];
	}
	right->n = T;
	child->n = T;
	right_count = T;
}

@copy_children_and_counts_if_not+=
else {
	for(int i=0; i<T; ++i) {
		right->children[i] = child->children[i+T];
		right->children[i]->parent = right;
	}

	right_count = 0;
	for(int i=0; i<T; ++i) {
		right->counts[i] = child->counts[i+T];
		right_count += right->counts[i];
	}
	right->n = T;
	child->n = T;
}


@insert_right_as_child_in_parent+=
bpnode* parent = child->parent;
for(int k=parent->n; k>j+1; --k) {
	parent->children[k] = parent->children[k-1];
}

for(int k=parent->n; k>j+1; --k) {
	parent->counts[k] = parent->counts[k-1];
}

parent->children[j+1] = right;

parent->counts[j] = parent->counts[j] - right_count;
parent->counts[j+1] = right_count;

parent->n++;

if(pright) {
	*pright = right;
}

@split_current_node+=
bpnode* right;
node_split(node->children[j], j, &right);
if(index >= T) {
	j++;
	index -= T;
}

@increase_counts_in_child+=
node->counts[j]++;

@recurse_on_children_insert+=
node_insert_nonfull(tree, node->children[j], index, value);

@create_new_root+=
bpnode* new_root = new bpnode;
new_root->leaf = false;
new_root->children[0] = tree->root;
new_root->counts[0] = tree->total;
new_root->n = 1;
new_root->parent = NULL;
tree->root->parent = new_root;

tree->root = new_root;

@split_root+=
node_split(new_root->children[0], 0);

@declare+=
auto print_tree(bptree* tree) -> void;

@define+=
auto print_tree(bptree* tree) -> void
{
	std::cout << "Count: " << tree->total << std::endl;
	print_node(tree->root);
}

@declare+=
auto print_node(bpnode* node, int indent = 0) -> void;

@define+=
auto print_node(bpnode* node, int indent) -> void
{
	if(node->leaf) {
		for(int j=0; j<indent; ++j) {
			std::cout << ".";
		}
		std::cout << "[" << node << "]" << std::endl;
		for(int j=0; j<indent; ++j) {
			std::cout << ".";
		}
		std::cout << "parent [" << node->parent << "]" << std::endl;
		for(int i=0; i<node->n; ++i) {
			for(int j=0; j<indent; ++j) {
				std::cout << " ";
			}
			std::cout << node->keys[i] << std::endl;
		}
	} else {
		for(int j=0; j<indent; ++j) {
			std::cout << ".";
		}
		std::cout << "[" << node << "]" << std::endl;
		for(int j=0; j<indent; ++j) {
			std::cout << ".";
		}
		std::cout << "parent [" << node->parent << "]" << std::endl;

		for(int i=0; i<node->n; ++i) {
			print_node(node->children[i], indent+1);
		}
	}
}

@insert_in_tree+=
tree_insert(tree, 0, 1);

@print_tree+=
print_tree(tree);

@declare+=
auto tree_delete(bptree* tree, int index) -> void;

@define+=
auto tree_delete(bptree* tree, int index) -> void
{
	delete_node_nonmin(tree, tree->root, index);
	tree->total--;
}

@declare+=
auto delete_node_nonmin(bptree* tree, bpnode* node, int index) -> void;

@define+=
auto delete_node_nonmin(bptree* tree, bpnode* node, int index) -> void
{
	@if_leaf_delete_key
	@otherwise_in_which_children_to_delete
}

@if_leaf_delete_key+=
if(node->leaf) {
	for(int i=index; i<node->n-1; ++i) {
		node->keys[i] = node->keys[i+1];
	}
	node->n--;
}

@otherwise_in_which_children_to_delete+=
else {
	int j=0;
	@search_which_child_contains_index_to_delete
	@if_child_is_minimum_merge

	node->counts[j]--;
	delete_node_nonmin(tree, node->children[j], index);
}

@search_which_child_contains_index_to_delete+=
while(j < node->n-1 && index >= node->counts[j]) {
	index -= node->counts[j];
	j++;
}

assert(index < node->counts[j]);

@if_child_is_minimum_merge+=
if(node->children[j]->n == T) {
	@try_to_borrow_from_left_sibling
	@try_to_borrow_from_right_sibling
	else {
		@otherwise_merge_with_left_sibling
		@otherwise_merge_with_right_sibling
		@if_only_child_remove_root
	}
}

@try_to_borrow_from_left_sibling+=
if(j > 0 && node->children[j-1]->n > T) {
	node->counts[j-1]--;
	node->counts[j]++;

	bpnode* left = node->children[j-1];
	bpnode* right = node->children[j];

	if(right->leaf) {
		for(int i=right->n-1; i>=0; --i) {
			right->keys[i+1] = right->keys[i];
		}
		right->keys[0] = left->keys[left->n-1];
	} else {
		for(int i=right->n-1; i>=0; --i) {
			right->children[i+1] = right->children[i];
			right->counts[i+1] = right->counts[i];
		}
		right->children[0] = left->children[left->n-1];
		right->counts[0] = left->counts[left->n-1];
	}
	
	left->n--;
	right->n++;
	index++;
}

@try_to_borrow_from_right_sibling+=
else if(j+1 < node->n && node->children[j+1]->n > T) {
	node->counts[j+1]--;
	node->counts[j]++;

	bpnode* left = node->children[j];
	bpnode* right = node->children[j+1];

	if(left->leaf) {
		left->keys[left->n] = right->keys[0];
		for(int i=0; i<right->n-1; ++i) {
			right->keys[i] = right->keys[i+1];
		}
	} else {
		left->children[left->n] = right->children[0];
		left->counts[left->n] = right->counts[0];

		for(int i=0; i<right->n-1; ++i) {
			right->children[i] = right->children[i+1];
			right->counts[i] = right->counts[i+1];
		}
	}

	left->n++;
	right->n--;
}

@otherwise_merge_with_left_sibling+=
if(j > 0) {
	bpnode* left = node->children[j-1];
	bpnode* right = node->children[j];

	@merge_right_to_left
	@remove_right_from_parent
	j = j-1;
}

@merge_right_to_left+=
int right_count = 0;
if(right->leaf) {
	for(int i=0; i<right->n; ++i) {
		left->keys[i+T] = right->keys[i];
	}
	right_count = T;
} else {
	for(int i=0; i<right->n; ++i) {
		left->counts[i+T] = right->counts[i];
		left->children[i+T] = right->children[i];
		left->children[i+T]->parent = left;
		right_count += right->counts[i];
	}
}
left->n += T;

@remove_right_from_parent+=
for(int i=j; i<node->n-1; ++i) {
	node->children[i] = node->children[i+1];
	node->counts[i] = node->counts[i+1];
}
index += node->counts[j-1];
node->counts[j-1] += right_count;
node->n--;

delete right;

@otherwise_merge_with_right_sibling+=
else {
	bpnode* left = node->children[j];
	bpnode* right = node->children[j+1];

	@merge_right_to_left
	@remove_right_from_parent_from_left
}

@remove_right_from_parent_from_left+=
for(int i=j+1; i<node->n-1; ++i) {
	node->children[i] = node->children[i+1];
	node->counts[i] = node->counts[i+1];
}
node->counts[j] += right_count;
node->n--;

delete right;

@if_only_child_remove_root+=
if(node->n == 1) {
	tree->root = tree->root->children[0];
	tree->root->parent = NULL;
	delete node;
	delete_node_nonmin(tree, tree->root, index);
	return;
}

@declare+=
auto tree_lookup(bptree* tree, int index) -> int;

@define+=
auto tree_lookup(bptree* tree, int index) -> int
{
	return node_lookup(tree->root, index);
}

@declare+=
auto node_lookup(bpnode* node, int index) -> int;

@define+=
auto node_lookup(bpnode* node, int index) -> int
{
	if(node->leaf) {
		return node->keys[index];
	} else {
		int j=0;
		while(index >= node->counts[j] && j < node->n) {
			index -= node->counts[j];
			j++;
		}
		return node_lookup(node->children[j], index);
	}
}


@declare+=
auto tree_reverse_lookup(bpnode* node, int offset) -> int;

@define+=
auto tree_reverse_lookup(bpnode* node, int offset) -> int
{
	if(!node->parent) {
		return offset;
	}

	else {
		bpnode* parent = node->parent;
		for(int i=0; i<parent->n; ++i) {
			if(parent->children[i] == node) {
				break;
			}
			offset += parent->counts[i];
		}
		return tree_reverse_lookup(parent, offset);
	}
}


@declare+=
auto tree_lookup(bptree* tree, int index, int* offset) -> bpnode*;

@define+=
auto tree_lookup(bptree* tree, int index, int* offset) -> bpnode*
{
	return node_lookup(tree->root, index, offset);
}

@declare+=
auto node_lookup(bpnode* node, int index, int* offset) -> bpnode*;

@define+=
auto node_lookup(bpnode* node, int index, int* offset) -> bpnode*
{
	if(node->leaf) {
		*offset = index;
		return node;
	} else {
		int j=0;
		while(index >= node->counts[j] && j < node->n) {
			index -= node->counts[j];
			j++;
		}
		return node_lookup(node->children[j], index, offset);
	}
}

@test_tree+=
for(int i=0; i<10; ++i) {
	tree_insert(tree, 0, i);
}

print_tree(tree);

for(int i=0; i<10; ++i) {
	int offset;
	bpnode* node = tree_lookup(tree, i, &offset);
	std::cout << tree_reverse_lookup(node, offset) << std::endl;
}
