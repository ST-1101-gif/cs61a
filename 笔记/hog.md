# <center> Hog
---
## Dice
### make
```py
def make_fair_dice(sides):
    """Return a die that returns 1 to SIDES with equal chance."""
    assert type(sides) == int and sides >= 1, 'Illegal value for sides'
    def dice():
        return randint(1,sides)
    return dice

four_sided = make_fair_dice(4)
six_sided = make_fair_dice(6)
```
to **bind name to function**:
- def 
- *assignment (`=`)*
### test
```bash
>>> counted_dice = make_test_dice(4, 1, 2, 6)
>>> roll_dice(3, counted_dice)
? 1
-- OK! --

>>> # Make sure you call dice exactly num_rolls times!
>>> # If you call it fewer or more than that, it won't be at the right spot in the cycle for the next roll
>>> # Note that a return statement within a loop ends the loop
>>> roll_dice(1, counted_dice)
? 4
-- Not quite. Try again! --

? 6
-- OK! --
```
the same object!!!

---
## Hog
### Overall
understand!!!
- the game rule & logic (psuedocode)
- job of function 
  - input & output
  - by specific & all types of **cases**
- control flow (never repeat)
- higher-order functions
    ```py 
    def f(x)
        def g(y)
            return... # taking x & y
        return g
    ```
    separate defining and calling 
  - **defining**: equivalent to function(x, y), just to change the signature
  - **calling**:
    x: directly pass to f
    y: from the caller-function of f

### is_always_roll
```py
def is_always_roll(strategy, goal=GOAL):
    first_roll = strategy(0, 0)
    for i in range(goal):
        for j in range(goal):
            curr_roll = strategy(i, j)
            if(curr_roll != first_roll):
                return False
    return True
```
wrong:
```py
if strategy in [always_roll(n) for n in range(11)]:
        return True 
    else:
        return False
```
Every time `always_roll` is called, a **new function object** will be returned, even if the passed parameter `n` are the *same*

### make_averaged
```py
def make_averaged(original_function, times_called=1000):
    """Return a function that returns the average value of ORIGINAL_FUNCTION
    called TIMES_CALLED times.

    >>> dice = make_test_dice(4, 2, 5, 1)
    >>> averaged_dice = make_averaged(roll_dice, 40)
    >>> averaged_dice(1, dice)  # The avg of 10 4's, 10 2's, 10 5's, and 10 1's
    3.0
    """
    def averaged(*args):
        total = 0
        for i in range(times_called):
            sample = original_function(*args)
            total += sample
        return total / times_called
    return averaged
```

***args syntax**