**predicate function**: functions that will return True or False.

Don't:
```py
def comp_equal(x):
        if f(g(x)) == g(f(x)):
            return True
        else:
            return False
```
But:
```py
def comp_equal(x):
        return f(g(x)) == g(f(x))
```

