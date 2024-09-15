#lang racket
(provide intersperse)

(define (intersperse lst pred separator)
  (define (helper lst last-satisfied?)
    (cond [(empty? lst) empty]
          [else
           (define item (car lst))
           (define current-satisfies? (pred item))
           (define new-tail (helper (cdr lst) current-satisfies?))
           (cond [(and last-satisfied? current-satisfies?)
                  (cons separator (cons item new-tail))]
                 [else (cons item new-tail)])]))
  (helper lst #f))

(module+ test
  (require rackunit)

  (check-equal? (intersperse '() even? 'x) '()
                "Empty list should return an empty list")

  (check-equal? (intersperse '(1 2 3 4 5) even? 'x) '(1 2 3 4 5)
                "List with no consecutive even numbers should remain unchanged")

  (check-equal? (intersperse '(2 4 6 1 8 10) even? 'x) '(2 x 4 x 6 1 8 x 10)
                "List with consecutive even numbers should have 'x' inserted between them")

  (check-equal? (intersperse '(2 4 6 8 10) even? 'x) '(2 x 4 x 6 x 8 x 10)
                "List with all even numbers should have 'x' inserted between all elements")

  (check-equal? (intersperse '(1) even? 'x) '(1)
                "Single-element list should remain unchanged")

  (check-equal? (intersperse '(2 4) even? 'x) '(2 x 4)
                "Two-element list with both elements satisfying predicate should have separator inserted")

  (check-equal? (intersperse '(1 2) even? 'x) '(1 2)
                "Two-element list with only one element satisfying predicate should remain unchanged")

  (check-equal? (intersperse '("a" "b" "cc" "d" "ee" "ff") (lambda (s) (> (string-length s) 1)) 'sep)
                '("a" "b" "cc" "d" "ee" sep "ff")
                "List with strings, separating strings longer than 1 character")

  (check-equal? (intersperse '(1 3 5 2 7 9 11) odd? 0) '(1 0 3 0 5 2 7 0 9 0 11)
                "List with odd numbers, using 0 as separator"))
