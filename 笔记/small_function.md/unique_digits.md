```py
def unique_digits(n):
    """Return the number of unique digits in positive integer n.

    >>> unique_digits(8675309) # All are unique
    7
    >>> unique_digits(13173131) # 1, 3, and 7
    3
    >>> unique_digits(101) # 0 and 1
    2
    """
    "*** YOUR CODE HERE ***"
```
两种思路
- 从给出的 n 出发，每次判断一位是否出现过（这也是人眼识别的逻辑）
  
- 先不管参数是什么， 从所有的可能性出发(**bucket**)
  条件：可能性少（总共只有 9 种 digits）
  
  ```py
    def has_digit(n, k):
        """Returns whether k is a digit in n.

        >>> has_digit(10, 1)
        True
        >>> has_digit(12, 7)
        False
        """
        assert k >= 0 and k < 10
        "*** YOUR CODE HERE ***"
    ```
