(define (over-or-under num1 num2) 
  (cond 
      ((< num1 num2) -1)
      ((> num1 num2) 1)
      (else 0)) )

(define (max a b)
  (if (> a b)
      a
      b))

(define (min a b)
  (if (> a b)
      b
      a))

(define (gcd a b) 
  (let (
    (small (min a b))
    (big (max a b))
    )
  (if (= (modulo big small) 0)
    small
    (gcd (modulo big small) small))))

(define (remove item lst) 
  (cond ((null? lst) lst)
      ((= (car lst) item) (remove item (cdr lst)))
      (else (cons (car lst) (remove item (cdr lst))))))

(define (duplicate lst) 
  (if (null? lst)
      lst
      (cons (car lst) (cons (car lst) (duplicate (cdr lst))))))

(expect (duplicate '(1 2 3)) (1 1 2 2 3 3))

(expect (duplicate '(1 1)) (1 1 1 1))

(define (composed f g) 
  (lambda (x) (f (g x))))

(define (repeat f n) 
  (if (equal? n 1)
      f
      (composed f (repeat f (- n 1)))))
