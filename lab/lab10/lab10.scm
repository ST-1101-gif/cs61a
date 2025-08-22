(define (exp b n)
  (define (helper n so-far) 
          (if (zero? n)
              so-far
              (helper (- n 1) (* so-far b))))
  (helper n 1))

(define (last s) 
        (if (null? (cdr s))
            (car s)
            (last (cdr s))))

(define (swap s)
  (define (change c s)
    (if (null? s)
        c
        (if (null? (cdr s))
            (append c (list (car s)))
            (change (append c (list (car (cdr s)) (car s))) (cdr (cdr s))))))
  (change nil s))

(define (concatenate s)
  (define (iter acc remaining)
    (if (null? remaining)
        acc
        (iter (append acc (car remaining)) (cdr remaining))))
  (iter '() s))

(define (filter pred lst) 'YOUR-CODE-HERE)

