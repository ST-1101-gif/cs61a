# <center> Data Processing
---
# 4.2 Implicit Sequences
A sequence can be represented without each element being stored explicitly in the memory of the computer. That is, we can construct an object that provides access to all of the elements of some sequential dataset without computing the value of each element in advance. Instead, we compute elements on demand.

**the range container**
when an element is requested from a range, it
is computed on demand
Hence, we can represent very large ranges of integers without using large blocks of
memory. 
Only the end points of the range are stored as part of the range object.
```py
>>> r = range(10000, 1000000000)
>>> r[45006230]
45016230    #adds the first element 10,000 to the index 45,006,230 to produce the element 45,016,230
```
Computing values on demand, rather than retrieving them from an existing representation, is an example of **lazy computation**.

## Iterators
a unified way to process elements of a **container** value sequentially

The iterator abstraction has two components: 
- retrieving the next element in the sequence being processed and 
- signaling that the end of the sequence has been reached and no further elements remain

An iterator *maintains local state* to represent its position in a sequence.
```py
>>> iterator = iter([1,2,3])
>>> type(iterator)
<class 'list_iterator'>

>>> r = range(1, 3)
>>> iter1 = iter(r)
>>> type(iter1)
<class 'range_iterator'>

>>> iter2 = iter(r)     # another iterator object
>>> iter3 = iter2       # the same iterator object
>>> iter4 = iter(iter3) # the same iterator
# Calling iter on an iterator will return *that* iterator, *not a copy*

>>> next(iter1)
1
>>> list(iter1)
[2]
>>> next(iter1)
2
>>> list(iter1)
[]
>>> next(iter1)
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
StopIteration

>>> next(iter2)
1
```
⚠️side effect
```py
>>> iter = iter([1, 2, 3])
>>> next(iter) == next(iter)
False
```

## Iterables
Any value that can produce iterators is called an **iterable value**.
- **Containers** such as lists, strings, tuples, sets, dictionaries and range
- **Iterators** are also iterables, because they can be passed to the iter function.

**unordered collections** such as dictionaries must define an ordering over their contents when they produce iterators

- If a key is added or removed, then all iterators become invalid. 
- changing the value of an existing key does not change the order of the contents.

## Built-in Iterators
Several built-in functions *take as arguments iterable values* and *return iterators*.  `map`, `filter`, `zip`, `reversed`
These functions are used extensively for **lazy sequence processing.**

```py
>>> m = map(lambda x: x * x, [3, 4, 5])
>>> next(m)
9
>>> next(m)
16
>>> f = filter(lambda x: x > 3, [3, 4, 5])
>>> next(f)
4
>>> next(f)
5
>>> z = zip([30, 40, 50], [3, 4, 5])
>>> next(z)
(30, 3)
>>> next(z)
(40, 4)
```
more about `zip`:
```py
>>> list(zip([1, 2, 3], [4, 5], [6, 7, 8]))
[(1, 4), (2, 5)]
```


## For Statements
Objects are iterable (an interface) if they have an `__iter__` method that returns an iterator
an iterator have an `__iter__` method that returns the iterator itself, so that all iterators are iterable.
```py
for <name> in <expression>:
    <suite>
```
To execute a for statement
1. evaluates the header `<expression>`, which must yield an iterable value. The `__iter__` method is invoked on that value. 
2. Until a StopIteration exception is raised, Python repeatedly 
   1. invokes the` __next__` method on that iterator and binds the result to the `<name>` in the for statement. 
   2. executes the `<suite>`.
   
## Adventages of Iterators
- make few assumptions on the data itself
- bundle the sequence and the position toghther

## Generators
```py
def letters_generator():
    current = 'a'       # initial
    while current <= 'd':   # end condition
        yield current       # content
        current = chr(ord(current)+1)   # next
```
When called, a **generator function** doesn't return a particular yielded value, but instead *a **generator** (which is a type of iterator) that itself can return the yielded
values.*

- start executing the body statements of its generator function when the first time `__next__` is invoked. 
- raises a StopIteration exception whenever its generator function returns.

**`yiel from` statements**
yields all values from an iterator or iterable 
```py
>>> def a_then_b(a, b):
        yield from a
        yield from b
>>> list(a_then_b([1, 2], [3, 4]))
[1, 2, 3, 4]
```
equivalent to:
```py
>>> def a_then_b(a, b):
        for x in a:
            yield x
        for x in b:
            yield x
```
recursion:
>partition

```py
def partition(n, m):
    if n > 0 and m > 0:
        if n == m:
            yield str(m)
        for p in partition(n - m, m):   # need extra computation -> for statement
            yield p + str(m)    
        yield from partition(n, m - 1)  # yield directly --> yield from statement
```
for base case n < 0 and m < 0, there is nothing to yield, so no need to write

Compared to return *a whole list*, we just think about yield *a single element*

        


## Iterable Interface
The built-in `iter` function invokes the `__iter__` method on its argument
`next` (or equivalently, each invocation of `__next__`)

```py
>>> class Letters:
        def __init__(self, start='a', end='e'):
            self.start = start
            self.end = end
        def __iter__(self):
            return LetterIter(self.start, self.end)
>>> b_to_k = Letters('b', 'k')
>>> first_iterator = b_to_k.__iter__()
>>> next(first_iterator)
'b'
>>> next(first_iterator)
'c'
>>> second_iterator = iter(b_to_k)
>>> second_iterator.__next__()
'b'
>>> first_iterator.__next__()
'd'
>>> first_iterator.__next__()
'e'
>>> second_iterator.__next__()
'c'
>>> second_iterator.__next__()
'd'
```

## Creating Iterables with Yield
```py
>>> def all_pairs(s):       # iterate over elements multiple times, using multiple iterators
        for item1 in s:
            for item2 in s:
                yield (item1, item2)
>>> list(all_pairs([1, 2, 3]))
[(1, 1), (1, 2), (1, 3), (2, 1), (2, 2), (2, 3), (3, 1), (3, 2), (3, 3)]

>>> class LettersWithYield:
        def __init__(self, start='a', end='e'):
            self.start = start
            self.end = end
        def __iter__(self):
            next_letter = self.start
            while next_letter < self.end:
                yield next_letter
                next_letter = chr(ord(next_letter)+1)   

>>> letters = LettersWithYield()
>>> list(all_pairs(letters))[:5]
[('a', 'a'), ('a', 'b'), ('a', 'c'), ('a', 'd'), ('b', 'a')]
```

## Iterator Interface

```py
class LetterIter:
    """An iterator over letters of the alphabet in ASCII order."""
    def __init__(self, start='a', end='e'):
        self.next_letter = start
        self.end = end
    def __next__(self):
        if self.next_letter == self.end:
            raise StopIteration     #  signals that the end of an underlying series has been reached
        letter = self.next_letter
        self.next_letter = chr(ord(letter)+1)       # change nonlocal value --> keep a local state
        return letter
```
Typically, an iterator is *not reset*; instead a new instance is created to start a new iteration.

iterates over the infinite series, never raises a StopIteration exception
```py
class Positives:
    def __init__(self):
        self.next_positive = 1
    def __next__(self):
        result = self.next_positive
        self.next_positive += 1
        return result
```

## Python Streams
A stream is a lazily computed linked list.


