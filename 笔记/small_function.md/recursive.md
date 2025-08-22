Define a function `cycle` that takes in three functions f1, f2, and f3, as arguments. cycle will return another function `g` that should take in an integer argument n and return another function `h`. 
 Here's what the final function h should do to x for a few values of n:

- n = 0, return x
- n = 1, apply f1 to x, or return f1(x)
- n = 2, apply f1 to x and then f2 to the result of that, or return f2(f1(x))
- n = 3, apply f1 to x, f2 to the result of applying f1, and then f3 to the result of applying f2, or f3(f2(f1(x)))
- n = 4, start the cycle again applying f1, then f2, then f3, then f1 again, or f1(f3(f2(f1(x))))
- And so forth.
```py
def cycle(f1, f2, f3):
    def g(n):
        def h(x):
            if n == 0:
                return x
            return cycle(f2, f3, f1)(n - 1)(f1(x))
        return h
    return g
```

---
```py
def subseqs(s):
    """Return a nested list (a list of lists) of all subsequences of S.
    The subsequences can appear in any order. You can assume S is a list.

    >>> seqs = subseqs([1, 2, 3])
    >>> sorted(seqs)
    [[], [1], [1, 2], [1, 2, 3], [1, 3], [2], [2, 3], [3]]
    >>> subseqs([])
    [[]]
    """
    if s == []:
        return [[]]
    else:
        rest = s[1:]
        return subseqs(rest) + [[s[0]] + subs for subs in subseqs(rest)] 
```
wrong:

```py
def subseqs(s):
    if s == []:
        return [[]]
    else:
        first = s[0]
        del s[0]
        return subseqs(s) + [[first] + subs for subs in subseqs(s)] 
```
the first call `subseqs(s)` will change s, causing error in the second call
==alert to side-effect in tree recursion!!!== 


wrong:
```py
def subseqs(s):
    if s == []:
        return [[]]
    else:
        rest = s[1:]
        return subseqs(rest) + [subs.append(s[0]) for subs in subseqs(rest)]
```
- not satisfy the definition of **subsequence**
- the return value of list.append() is **None**
  ==make clear the return value of built-in functions==


---
```py
def interleaved_sum(n, f_odd, f_even):
    """Compute the sum f_odd(1) + f_even(2) + f_odd(3) + ..., up
    to n.

    # ban loops and %
    """
    def part_sum(k):
        if k > n:
            res = 0
        else:
            res = f_odd(k)
            if k + 1 <= n:
                res += f_even(k + 1) + part_sum(k + 2)
        return res
    return part_sum(1)
```
- Since `%` is banned, we cannot compute whether n is odd or even, so consider calculate *from left side* 
- To simplify, the iteration calls *changes the value of parameter each time*
--> help to decide the choice of parameter (*what is changing?*)
- the parameter changes closer to the base case each time
--> help to decide the base case(*change to what?*)
- if the chosen parameter (to compute) are not the same as the the the given parameter(to understand), just write an **inner helper function** and call it
- each call not necessarily takes *1* step, it can take 2, 3...
---
```py
def next_smaller_dollar(bill):
    """Returns the next smaller bill in order."""
    if bill == 100:
        return 50
    if bill == 50:
        return 20
    if bill == 20:
        return 10
    elif bill == 10:
        return 5
    elif bill == 5:
        return 1

def count_dollars(total):
    """Return the number of ways to make change.

    >>> count_dollars(15)  # 15 $1 bills, 10 $1 & 1 $5 bills, ... 1 $5 & 1 $10 bills
    6
   
    # ban iteration
    """
    def constrained_count(total, largest_bill):
        if total == 0:
            return 1
        if total < 0:
            return 0
        if largest_bill == None:
            return 0
        without_dollar_bill = constrained_count(total, next_smaller_dollar(largest_bill))
        with_dollar_bill = constrained_count(total - largest_bill, largest_bill)
        return without_dollar_bill + with_dollar_bill
    return constrained_count(total, 100)
```
think of `count_partitions`

possibilities / cases: a **partition**!
- take m
- not take m
---
in `cats`
```py
def furry_fixes(typed, source, limit):
    """A diff function for autocorrect that determines how many letters
    in TYPED need to be substituted to create SOURCE, then adds the difference in
    their lengths to this value and returns the result.

    Arguments:
        typed: a starting word
        source: a string representing a desired goal word
        limit: a number representing an upper bound on the number of chars that must change

    >>> big_limit = 10
    >>> furry_fixes("nice", "rice", big_limit)    # Substitute: n -> r
    1
    >>> furry_fixes("range", "rungs", big_limit)  # Substitute: a -> u, e -> s
    2
    >>> furry_fixes("pill", "pillage", big_limit) # Don't substitute anything, length difference of 3.
    3
    >>> furry_fixes("roses", "arose", big_limit)  # Substitute: r -> a, o -> r, s -> o, e -> s, s -> e
    5
    >>> furry_fixes("rose", "hello", big_limit)   # Substitute: r->h, o->e, s->l, e->l, length difference of 1.
    5
    """
    # BEGIN PROBLEM 6
    fix_num = 0
    def count(typed, source):
        nonlocal fix_num
        if fix_num > limit:
            return 100
        elif len(typed) == 0:
            fix_num += len(source)
            return len(source)
        elif len(source) == 0:
            fix_num += len(typed)
            return len(typed)
        else:
            fix_num += typed[0] != source[0]
            return (typed[0] != source[0]) + count(typed[1:], source[1:])
    count(typed, source)
    return  fix_num
```

```py
def minimum_mewtations(typed, source, limit):
    """A diff function for autocorrect that computes the edit distance from TYPED to SOURCE.
    This function takes in a string TYPED, a string SOURCE, and a number LIMIT.

    Arguments:
        typed: a starting word
        source: a string representing a desired goal word
        limit: a number representing an upper bound on the number of edits

    >>> big_limit = 10
    >>> minimum_mewtations("cats", "scat", big_limit)       # cats -> scats -> scat
    2
    >>> minimum_mewtations("purng", "purring", big_limit)   # purng -> purrng -> purring
    2
    >>> minimum_mewtations("ckiteus", "kittens", big_limit) # ckiteus -> kiteus -> kitteus -> kittens
    3
    """
    if limit < 0:
        return limit + 1
    if len(typed) == 0:
        return len(source) 
    if len(source) == 0:
        return len(typed)
    if typed[0] == source[0]: 
        return minimum_mewtations(typed[1:], source[1:], limit)
    else:
        add = 1 + minimum_mewtations(typed, source[1:], limit - 1)
        remove = 1 + minimum_mewtations(typed[1:], source, limit - 1)
        substitute = 1 + minimum_mewtations(typed[1:], source[1:], limit - 1)
        return min(add, remove, substitute)
```
---

```py
def buy(fruits_to_buy, prices, total_amount):
    """Print ways to buy some of each fruit so that the sum of prices is amount.

    >>> prices = {'oranges': 4, 'apples': 3, 'bananas': 2, 'kiwis': 9}
    >>> buy(['apples', 'oranges', 'bananas'], prices, 16)
    [2 apples][1 orange][3 bananas]
    [2 apples][2 oranges][1 banana]
    """
    def add(fruits, amount, cart):
        if fruits == [] and amount == 0:
            print(cart)
        elif fruits and amount > 0:
            fruit = fruits[0]
            price = prices[fruit]
            for k in range(1, amount // price + 1):
                # Hint: The display function will help you add fruit to the cart.
                add(fruits[1:], amount - k * price, cart + display(fruit, k))
    add(fruits_to_buy, total_amount, '')


def display(fruit, count):
    """Display a count of a fruit in square brackets.

    >>> display('apples', 3)
    '[3 apples]'
    >>> print(display('apples', 3) + display('kiwis', 3))
    [3 apples][3 kiwis]
    """
    assert count >= 1 and fruit[-1] == 's'
    if count == 1:
        fruit = fruit[:-1]  # get rid of the plural s
    return '[' + str(count) + ' ' + fruit + ']'
```
every `k` represents a choice you make for the next fruit

every branch causes a *seperate* iteractive chain that *not affect each other*
(you don't need to think about it)

---
in `cats` project
```py
def minimum_mewtations(typed, source, limit):
    """A diff function for autocorrect that computes the edit distance from TYPED to SOURCE.
    This function takes in a string TYPED, a string SOURCE, and a number LIMIT.

    Arguments:
        typed: a starting word
        source: a string representing a desired goal word
        limit: a number representing an upper bound on the number of edits

    >>> big_limit = 10
    >>> minimum_mewtations("cats", "scat", big_limit)       # cats -> scats -> scat
    2
    >>> minimum_mewtations("purng", "purring", big_limit)   # purng -> purrng -> purring
    2
    >>> minimum_mewtations("ckiteus", "kittens", big_limit) # ckiteus -> kiteus -> kitteus -> kittens
    3
    """
    if limit < 0:
        return limit + 1
    if len(typed) == 0:
        return len(source) 
    if len(source) == 0:
        return len(typed)
    if typed[0] == source[0]: 
        return minimum_mewtations(typed[1:], source[1:], limit)
    else:
        add = 1 + minimum_mewtations(typed, source[1:], limit - 1)
        remove = 1 + minimum_mewtations(typed[1:], source, limit - 1)
        substitute = 1 + minimum_mewtations(typed[1:], source[1:], limit - 1)
        return min(add, remove, substitute)
```
you can change `limit`!!! 
think of **all the parameters** to change 

---
## Tail Recursion
use *extra parameter to keep track of progress so far*
>num splits
```py
def num_splits(s, d):
    """Return the number of ways in which s can be partitioned into two
    sublists that have sums within d of each other.

    >>> num_splits([1, 5, 4], 0)  # splits to [1, 4] and [5]
    1
    >>> num_splits([6, 1, 3], 1)  # no split possible
    0
    >>> num_splits([-2, 1, 3], 2) # [-2, 3], [1] and [-2, 1, 3], []
    2
    >>> num_splits([1, 4, 6, 8, 2, 9, 5], 3)
    12
    """
    def helper(s, left, right):
        if s == []:
            if 0 < right - left <= d:
                return 1
            elif right - left == 0:
                return 0.5
            else:
                return 0
        return helper(s[1:], left + s[0], right) + helper(s[1:], left, right + s[0])
    return int(helper(s, 0, 0))
```

```py
def num_splits(s, d):
    def difference_so_far(s, difference):
        if not s:
            if abs(difference) <= d:
                return 1
            else:
                return 0
        element = s[0]
        s = s[1:]
        return difference_so_far(s, difference + element) + difference_so_far(s, difference - element)
    return difference_so_far(s, 0)//2
```
对于所有的函数一定要先思考它的 job 到底是什么！！！

`num_splits(s, d)` 本身是传一个列表和差值， 返回 0 <= 右 - 左 <= d 的 partion 个数
思考，处理完s 的第一个元素之后对于s[1:]的处理方法是一样的吗？
不是！not the same type of questions!!!
如果 s[0] 是正数，放到右边，很可能对于 s[1:] 的分割并不是右边 >= 左边了
so,
必须要有一个**跟踪全局**的参数!!!