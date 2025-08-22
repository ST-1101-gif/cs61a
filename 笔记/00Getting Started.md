# <center> Getting Started
---

## Useful Python Command Line Options
```bash
python3 lab00.py
```
```bash
python3 -i lab00.py
```
- opens an interactive session (with a >>> prompt)
- To exit, type exit() or Ctrl-D
```bash
python3 -m doctest lab00.py
```
- Runs the **doctests** in a file
**doctests**:  
    - the examples in the **docstrings** of functions
    - Each test in the file consists of >>> followed by some Python code and the expected output.
    - example

    ```py
    def div(a, b):
    """
    >>> div(10, 0)
    ZeroDivisionError
    """
    return a / b 
    ```

- When our code passes all of the doctests, no output is displayed. Otherwise, information about the tests that failed will be displayed.
## Debug
- It is generally bad practice to release code with debugging print statements left in
- It is generally good practice to release code with assertion statements left in
- Debugging is not a substitute for testing

If your function contains a call to print that starts with "DEBUG:", then this line will be ignored by OK. (Otherwise, including extra print calls can cause tests to fail because of the additional output displayed.)
```py
print("DEBUG:", x)
```
open an interactive terminal to investigate a failing test for question sum_digits in assignment lab01
```bash
python3 ok -q sum_digits -i
```


## print & return
```bash
>>> def bake(cake, make):
...    if cake == 0:
...        cake = cake + 1
...        print(cake)
...    if cake == 1:
...        print(make)
...    else:
...        return cake
...    return make
>>> bake(0, 29)

(line 1)? mashed potatoes
(line 2)? 'mashed potatoes'
```