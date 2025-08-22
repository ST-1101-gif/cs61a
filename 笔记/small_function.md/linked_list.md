Decimal Expansion
```py
>>> x = Link(0, Link(0, Link(4, Link(5))))
>>> x.rest.rest.rest.rest = x.rest.rest
>>> display(x, 20)
0.04545454545454545454...
```
not copied, but **the same object**!!!
so it's a circle
the same as the linked list in C

```py
def divide(n, d):
    """Return a linked list with a cycle containing the digits of n/d.

    >>> display(divide(5, 6))
    0.8333333333...
    >>> display(divide(2, 7))
    0.2857142857...
    >>> display(divide(1, 2500))
    0.0004000000...
    >>> display(divide(3, 11))
    0.2727272727...
    >>> display(divide(3, 99))
    0.0303030303...
    """
    assert n > 0 and n < d
    result = Link(0)  # The zero before the decimal point
    cache = {}
    tail = result
    while n not in cache:
        q, r = 10 * n // d, 10 * n % d
        tail.rest = Link(q)
        tail = tail.rest
        cache[n] = tail
        n = r
    tail.rest = cache[n]
    return result
```

---

```py
def store_digits(n):
    """Stores the digits of a positive number n in a linked list.

    >>> s = store_digits(1)
    >>> s
    Link(1)
    >>> store_digits(2345)
    Link(2, Link(3, Link(4, Link(5))))
    >>> store_digits(876)
    Link(8, Link(7, Link(6)))
    >>> store_digits(2450)
    Link(2, Link(4, Link(5, Link(0))))
    >>> store_digits(20105)
    Link(2, Link(0, Link(1, Link(0, Link(5)))))
    >>> # a check for restricted functions
    >>> import inspect, re
    >>> cleaned = re.sub(r"#.*\\n", '', re.sub(r'"{3}[\s\S]*?"{3}', '', inspect.getsource(store_digits)))
    >>> print("Do not use str or reversed!") if any([r in cleaned for r in ["str", "reversed"]]) else None
    """
    "*** YOUR CODE HERE ***"
    if n < 10:
        return Link(n)
    all_but_last, last = n // 10, n % 10
    link = store_digits(all_but_last)
    while not link is Link.empty:
        link = link.rest
    link = Link(last)
```

However, the way you're updating `link` inside the loop (`link = link.rest`) doesn't actually modify the original linked list. Instead, you're just reassigning the local variable `link` to `None` when you reach the end of the list.
After the loop, you try to set `link = Link(last)`, but at this point, `link` is no longer pointing to the original linked list—it’s just a local variable that was reassigned to `None`.

still wrong:
```py
def store_digits(n):
    if n < 10:
        return Link(n)
    all_but_last, last = n // 10, n % 10
    link = store_digits(all_but_last)       # return value 
    while not link.rest is Link.empty:
        link = link.rest
    link.rest = Link(last)      # manipulate
```
didn't make clear the job of the function!

3 parts: **consistent**!
- base case -- actual action 
- the next step -- actual action 
- recursion call -- utilize the outcome


return or manipulate??? 
Don't contradict!

true:
```py
def store_digits(n):
    if n < 10:
        return Link(n)
    all_but_last, last = n // 10, n % 10
    link = store_digits(all_but_last)
    cur_link = link
    while cur_link.rest is not Link.empty:
        cur_link = cur_link.rest
    cur_link.rest = Link(last)
    return link
```

---
