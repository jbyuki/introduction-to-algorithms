btree2
======


Data structure based on B+ - tree. This can be used as an array-like 
data structure where the following operations are supported:

* insert at [i] : O(log n)
* delete at [i] : O(log n)
* lookup at [i] : O(log n)
* reverse lookup of i: O(log n)   [not implemented]


Benchmarks
----------

The performances are about the same between btree/ and btree2/, but
the btree2/ implementation is slighter simpler ( 500 LOC vs 600 LOC ).
The advantage of btree/ is less memory usage because it stores values in internal nodes but comes at additionnal code complexity.

On my machine the benchmarks runs in ~70 ms. The benchmark code is: 

```cpp

for(int i=0; i<1000; ++i) {
    bptree* tree = create_tree();

    for(int j=0; j<1000; ++j) {
        tree_insert(tree, 0, j);
    }

    for(int j=0; j<1000; ++j) {
        tree_delete(tree, 0);
    }
    destroy_tree(tree);
}
```
