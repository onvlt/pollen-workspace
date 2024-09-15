#lang racket
(provide add-between-neighbors)

(define (add-between-neighbors lst proc)
  (define (helper lst acc)
    (cond
      [(or (null? lst) (null? (cdr lst)))
       (reverse (append lst acc))]
      [else
       (let* ([first (car lst)]
              [second (cadr lst)]
              [result (proc first second)])
         (if result
             (helper (cdr lst) (cons result (cons first acc)))
             (helper (cdr lst) (cons first acc))))]))

  (helper lst '()))

(module+ test
  (require rackunit)
  (check-equal? (add-between-neighbors '() (lambda (a b) #t))
                '()
                "Empty list should return an empty list")

  ; Test 2: Single element list
  (check-equal? (add-between-neighbors '(1) (lambda (a b) #t))
                '(1)
                "Single element list should return the same list")

  ; Test 3: Two element list with truthy proc
  (check-equal? (add-between-neighbors '(1 2) (lambda (a b) 'x))
                '(1 x 2)
                "Two element list with truthy proc should insert element")

  ; Test 4: Two element list with falsy proc
  (check-equal? (add-between-neighbors '(1 2) (lambda (a b) #f))
                '(1 2)
                "Two element list with falsy proc should not insert element")

  ; Test 5: Longer list with alternating truthy and falsy results
  (check-equal? (add-between-neighbors '(1 2 3 4 5)
                                       (lambda (a b) (if (odd? a) 'x #f)))
                '(1 x 2 3 x 4 5)
                "Should insert 'x' only after odd numbers")

  ; Test 6: All elements cause insertion
  (check-equal? (add-between-neighbors '(1 2 3 4) (lambda (a b) '+))
                '(1 + 2 + 3 + 4)
                "Should insert '+' between all elements")

  ; Test 7: No elements cause insertion
  (check-equal? (add-between-neighbors '(1 2 3 4) (lambda (a b) #f))
                '(1 2 3 4)
                "Should not insert anything")

  ; Test 8: Proc returns different values
  (check-equal? (add-between-neighbors '(1 2 3 4 5)
                                       (lambda (a b) (if (< a b) (+ a b) #f)))
                '(1 3 2 5 3 7 4 9 5)
                "Should insert sum when second number is larger")

  ; Test 9: Proc uses both arguments
  (check-equal? (add-between-neighbors '("a" "ab" "abc" "b" "bc")
                                       (lambda (a b)
                                         (if (and (< (string-length a) (string-length b))
                                                  (string=? (substring b 0 (string-length a)) a))
                                             'substring
                                             #f)))
                '("a" substring "ab" substring "abc" "b" substring "bc")
                "Should insert 'substring' when second string is longer and starts with first string")

  ; Test 10: List with repeated elements
  (check-equal? (add-between-neighbors '(1 1 2 2 3 3)
                                       (lambda (a b) (if (= a b) 'same #f)))
                '(1 same 1 2 same 2 3 same 3)
                "Should insert 'same' between equal adjacent numbers"))
