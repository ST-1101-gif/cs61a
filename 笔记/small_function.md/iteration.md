## while & for 

Damaging a bee may cause it to be removed from its place; when an insect dies, it is removed from its current place. If you iterate over a list, but change the contents of that list at the same time, you may not visit all the elements. This can be prevented by making a copy of the list. You can either use a list slice, or use the built-in list function to make sure the original list is not affected.

from `ants`
```py
for b in self.place.bees:
            b.reduce_health(self.damage)    # cause error since bees may be removed
```

```py
bees = self.place.bees[:]
for b in bees:
    b.reduce_health(self.damage)
```


in `ants`
```py
def nearest_bee(self):
        """Return a random Bee from the nearest Place (excluding the Hive) that contains Bees and is reachable from
        the ThrowerAnt's Place by following entrances.

        This method returns None if there is no such Bee (or none in range).
        """
        search_plc = self.place
        step = 0    # important!!!
        for step in range(self.lower_bound):
            search_plc = search_plc.entrance
        while step < self.upper_bound:
            if search_plc.is_hive:
                return 
            if search_plc.bees:
                return random_bee(search_plc.bees)
            search_plc = search_plc.entrance
            step += 1
```
如果 self.lower_bound 为 0 时，for 循环不会执行，那么 step 变量就不会被创建，但在 while 循环中仍然尝试使用它

## iterator & generator
```py
def gen_fib():
    n, add = 0, 1
    while True:
        yield n
        n, add = n + add, n

next(filter(lambda n: n > 2024, gen_fib()))
```

if parameter contains iterator
```py
def differences(t):
    """Yield the differences between adjacent values from iterator t.

    >>> list(differences(iter([5, 2, -100, 103])))
    [-3, -102, 203]
    >>> next(differences(iter([39, 100])))
    61
    """
    last_x = next(t)
    for x in t:
        yield x - last_x
        last_x = x
```

recursion -- `yield from`
```py
def primes_gen(n):
    """Generates primes in decreasing order.
    >>> pg = primes_gen(7)
    >>> list(pg)
    [7, 5, 3, 2]
    """
    if n == 1:
        return
    if is_prime(n):
        yield n
    yield from primes_gen(n-1)
```

```py
def partition_gen(n, m):
    """Yield the partitions of n using parts up to size m.

    >>> for partition in sorted(partition_gen(6, 4)):
    ...     print(partition)
    1 + 1 + 1 + 1 + 1 + 1
    1 + 1 + 1 + 1 + 2
    1 + 1 + 1 + 3
    1 + 1 + 2 + 2
    1 + 1 + 4
    1 + 2 + 3
    2 + 2 + 2
    2 + 4
    3 + 3
    """
    assert n > 0 and m > 0
    if n == m:
        yield str(n)
    if n - m > 0:
        for p in partition_gen(n - m, m):
            yield p + ' + ' + str(m)
    if m > 1:
        yield from partition_gen(n, m-1)
```

```py
def make_generators_generator(g):
    """Generates all the "sub"-generators of the generator returned by
    the generator function g.

    >>> def every_m_ints_to(n, m):
    ...     i = 0
    ...     while (i <= n):
    ...         yield i
    ...         i += m

    >>> def every_3_ints_to_10():
    ...     for item in every_m_ints_to(10, 3):
    ...         yield item
    
    >>> for gen in make_generators_generator(every_3_ints_to_10):
    ...     print("Next Generator:")
    ...     for item in gen:
    ...         print(item)
    Next Generator:
    0
    Next Generator:
    0
    3
    Next Generator:
    0
    3
    6
    Next Generator:
    0
    3
    6
    9
    """
    def gener(x):
        for e in g():
            yield e
            if e == x:
                return
    for e in g():
        yield gener(e)
```

---
a clever method to verify if a linked list has a cycle
```py
def has_cycle_constant(link):
    """Return whether link contains a cycle.

    >>> s = Link(1, Link(2, Link(3)))
    >>> s.rest.rest.rest = s
    >>> has_cycle_constant(s)
    True
    >>> t = Link(1, Link(2, Link(3)))
    >>> has_cycle_constant(t)
    False
    """
    if link is Link.empty:
        return False
    slow, fast = link, link.rest
    while fast is not Link.empty:
        if fast.rest == Link.empty:
            return False
        elif fast is slow or fast.rest is slow:
            return True
        else:
            slow, fast = slow.rest, fast.rest.rest
    return False
```