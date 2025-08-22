def fit(total, n):
    def f(total, n, k):
        if total == 0 and n == 0:
            return True
        if total < k * k:
            return False
        return f(total, n, k + 1) or f(total - k*k, n - 1, k)
            