```py
def prune_leaves(t, vals):
    """Return a modified copy of t with all leaves that have a label
    that appears in vals removed.  Return None if the entire tree is
    pruned away.

    >>> t = tree(2)
    >>> print(prune_leaves(t, (1, 2)))
    None
    >>> numbers = tree(1, [tree(2), tree(3, [tree(4), tree(5)]), tree(6, [tree(7)])])
    >>> print_tree(numbers)
    1
      2
      3
        4
        5
      6
        7
    >>> print_tree(prune_leaves(numbers, (3, 4, 6, 7)))
    1
      2
      3
        5
      6
    """
    if is_leaf(t) and (label(t) in vals):
        return None
        new_branches = []   # if you cannot change , save!
        for b in branches(t):
        new_branch = prune_leaves(b, vals)
        if new_branch:
            new_branches += [new_branch]    # or use append()
        return tree(label(t), new_branches)
```
Apart from ***to** the base case*, also think ***from** the base case*

the job of the function is to **return** a new tree rather than **manipulate** it! 

wrong:
```py
def prune_leaves(t, vals):
    if t == []:
        return None
    elif is_leaf(t):
        if t[0] in vals:
            return None
        else:
            return t
    else:
        for subt in t[1:]:
            subt = prune_leaves(subt, vals) # useless! 
    return t
```
```py
a = [1, 2, 3]
x = a[0]    # int type, immutable!
x = 100     # a is never changed
```

wrong:
```py
if is_leaf(t) and (label(t) in vals):
      return None
    new_branches = []
    for b in branches(t):
      new_branch = prune_leaves(b, vals)
      if new_branch:
        new_branches += new_branch
    return tree(label(t), new_branches)
```
differenciate `+` and `append()` !!!

---
```py
def yield_paths(t, value):
    """
    Yields all possible paths from the root of t to a node with the label
    value as a list.

    >>> t1 = tree(1, [tree(2, [tree(3), tree(4, [tree(6)]), tree(5)]), tree(5)])
    >>> print_tree(t1)
    1
      2
        3
        4
          6
        5
      5
    >>> next(yield_paths(t1, 6))
    [1, 2, 4, 6]
    >>> path_to_5 = yield_paths(t1, 5)
    >>> sorted(list(path_to_5))
    [[1, 2, 5], [1, 5]]

    >>> t2 = tree(0, [tree(2, [t1])])
    >>> print_tree(t2)
    0
      2
        1
          2
            3
            4
              6
            5
          5
    >>> path_to_2 = yield_paths(t2, 2)
    >>> sorted(list(path_to_2))
    [[0, 2], [0, 2, 1, 2]]
    """
    if label(t) == value:
        yield [label(t)]
    for b in branches(t):
        for path in yield_paths(b, value):
            yield [label(t)] + path
```
not find: return `None` (implicitly!)


---

```py
def delete(t, x):
    """Remove all nodes labeled x below the root within Tree t. When a non-leaf
    node is deleted, the deleted node's children become children of its parent.

    The root node will never be removed.

    >>> t = Tree(3, [Tree(2, [Tree(2), Tree(2)]), Tree(2), Tree(2, [Tree(2, [Tree(2), Tree(2)])])])
    >>> delete(t, 2)
    >>> t
    Tree(3)
    >>> t = Tree(1, [Tree(2, [Tree(4, [Tree(2)]), Tree(5)]), Tree(3, [Tree(6), Tree(2)]), Tree(4)])
    >>> delete(t, 2)
    >>> t
    Tree(1, [Tree(4), Tree(5), Tree(3, [Tree(6)]), Tree(4)])
    >>> t = Tree(1, [Tree(2, [Tree(4), Tree(5)]), Tree(3, [Tree(6), Tree(2)]), Tree(2, [Tree(6),  Tree(2), Tree(7), Tree(8)]), Tree(4)])
    >>> delete(t, 2)
    >>> t
    Tree(1, [Tree(4), Tree(5), Tree(3, [Tree(6)]), Tree(6), Tree(7), Tree(8), Tree(4)])
    """
    new_branches = []
    for b in t.branches:
        delete(b, x)
        if b.label == x:
            new_branches += b.branches
        else:
            new_branches.append(b)
    t.branches = new_branches
```
**recursive faith**!
just make clear the relationship of input and output / the job of the function
- return a new tree?
- manipulate the original tree? (no need to return) 

`delete` each branch, then manipulate their roots
rather than cope with their roots first

- take 1 step -> call recursion
- call recursion -> take 1 step

```py
for b in t.branches:
  if b.label == x:
    new_branches += [delete(sub_branch) for sub_branch in b.branches]   
    # if the sub_branch.lebel == x, it can't be deleted
  else:
    new_branch.append(delete(b, x))
```

---
```py
def long_paths(tree, n):
    """Return a list of all paths in tree with length at least n.

    >>> t = Tree(3, [Tree(4), Tree(4), Tree(5)])
    >>> left = Tree(1, [Tree(2), t])
    >>> mid = Tree(6, [Tree(7, [Tree(8)]), Tree(9)])
    >>> right = Tree(11, [Tree(12, [Tree(13, [Tree(14)])])])
    >>> whole = Tree(0, [left, Tree(13), mid, right])
    >>> for path in long_paths(whole, 2):
    ...     print(path)
    ...
    <0 1 2>
    <0 1 3 4>
    <0 1 3 4>
    <0 1 3 5>
    <0 6 7 8>
    <0 6 9>
    <0 11 12 13 14>
    >>> for path in long_paths(whole, 3):
    ...     print(path)
    ...
    <0 1 3 4>
    <0 1 3 4>
    <0 1 3 5>
    <0 6 7 8>
    <0 11 12 13 14>
    >>> long_paths(whole, 4)
    [Link(0, Link(11, Link(12, Link(13, Link(14)))))]
    """
    paths = []
    if n <= 0 and tree.is_leaf():
        paths.append(Link(tree.label))
    for b in tree.branches:
        for path in long_paths(b, n - 1):
            paths.append(Link(tree.label, path))
    return paths
```

wrong:
```py
def long_paths(tree, n):
    paths = []
    if tree.is_leaf():
        if n <= 1:
            return [Link(tree.label)]
        else:
            return []
    for b in tree.branches:
        b_paths = long_paths(b, n - 1)
        for path in b_paths:
             rest = path
             path.first = tree.label
             path.rest = rest
        paths += b_paths
    return paths
```
- you are changing the object *which may be used in other path*, other than create a new one
==alert to side effect in **tree recursion**!!!==

- the base case:
  there are 2 parameters changing / **decreasing**: the tree and n
  but just focus on one


---
in-order traversal
```py
def in_order_traversal(t):
    def in_order(lst, t):
      if t,is_leaf():
        return [t.label]
      lst += in_order_traversal(t.branches[0])
      lst.append(t.label)
      for b in t.branches[1:]:
        lst += in_order_traversal(b)
      return lst
    return in_order([], t)    # don't forget! the job is to return, not manupulate!
```
**function abstraction!!!
make clear the job of function, then you can:
use it before implement it!!!**

better:
```py
def in_order_traversal(t):
    if t.is_leaf():
        yield t.label
    else:
        left, right = t.branches  # get lst[0] and lst[1:]
        yield from in_order_traversal(left)
        yield t.label
        yield from in_order_traversal(right)
```
use **iterator** (lazily) rather than list (save all) may simplify some questions