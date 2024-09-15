#lang racket
(provide split-by split-by-separator)

(define (split-by lst pred)
  (define (split-helper remaining-lst acc)
    (cond
      [(empty? remaining-lst) (reverse acc)]
      [else
       (define-values (section rest) (splitf-at remaining-lst (negate pred)))
       (if (empty? section)
           (split-helper (cdr rest) acc)
           (split-helper rest (cons section acc)))]))
  (split-helper lst '()))

(define (split-by-separator lst separator)
  (define (separator? x) (equal? x separator))
  (split-by lst separator?))

(module+ test
  (require rackunit)

  (check-equal?
   (split-by '(1 2 3 4 5 6 7 8 9 10) even?)
   '((1) (3) (5) (7) (9))
   "Should split list into odd number sections")

  (check-equal?
   (split-by '() even?)
   '()
   "Empty list should return empty list")

  (check-equal?
   (split-by '(2 4 6 8 10) even?)
   '()
   "List with all matching elements should return empty list")

  (check-equal?
   (split-by '(1 3 5 7 9) even?)
   '((1 3 5 7 9))
   "List with no matching elements should return single sublist")

  (check-equal?
   (split-by '(2 1 3 5 7 4) even?)
   '((1 3 5 7))
   "Should handle matching first and last elements")

  (check-equal?
   (split-by '(1 2 3 6 4 5 7 8 3 9) (λ (x) (> x 5)))
   '((1 2 3) (4 5) (3))
   "Should work with custom predicates")

  (check-equal?
   (split-by '(2) even?)
   '()
   "Single element matching predicate should return empty list")

  (check-equal?
   (split-by '(1) even?)
   '((1))
   "Single element not matching predicate should return list with that element")

  (check-equal?
   (split-by '(1 2 a 3 4 b 5 6) symbol?)
   '((1 2) (3 4) (5 6))
   "Should split list at symbol separators")

  (check-equal?
   (split-by '(a 1 2 3 b 4 5 c) symbol?)
   '((1 2 3) (4 5))
   "Should handle symbols at start and end")

  (check-equal?
   (split-by '(1 a b 2 3 c c 4 d 5) symbol?)
   '((1) (2 3) (4) (5))
   "Should handle consecutive symbols")

  (check-equal?
   (split-by '(a b c d) symbol?)
   '()
   "List with only symbols should return empty list")

  (check-equal?
   (split-by '(1 "two" 3 4.0 #t) symbol?)
   '((1 "two" 3 4.0 #t))
   "List with mixed types but no symbols should return single sublist")

  (check-equal?
   (split-by '(a 1 "two" b 3 #t c 4.0 d) symbol?)
   '((1 "two") (3 #t) (4.0))
   "Should correctly split complex mixed list")

  (check-equal?
   (split-by-separator '(1 2 a 3 4 a 5 6) 'a)
   '((1 2) (3 4) (5 6))
   "Should split list at symbol 'a")

  (check-equal?
   (split-by-separator '(a b 1 c d 1 e f) 1)
   '((a b) (c d) (e f))
   "Should split list at number 1")

  (check-equal?
   (split-by-separator '() 'a)
   '()
   "Empty list should return empty list")

  (check-equal?
   (split-by-separator '(1 2 3 4 5) 'a)
   '((1 2 3 4 5))
   "List with no separators should return single sublist")

  (check-equal?
   (split-by-separator '(a a a a) 'a)
   '()
   "List with all separators should return empty list")

  (check-equal?
   (split-by-separator '(a 1 2 3 a 4 5 a) 'a)
   '((1 2 3) (4 5))
   "Should handle separators at start and end")

  (check-equal?
   (split-by-separator '(1 a a 2 3 a a 4 a 5) 'a)
   '((1) (2 3) (4) (5))
   "Should handle consecutive separators")

  (check-equal?
   (split-by-separator '("apple" "banana" "split" "cherry" "split" "date") "split")
   '(("apple" "banana") ("cherry") ("date"))
   "Should work with string separators")

  (check-equal?
   (split-by-separator '(#t 1 2 #f 3 4 #t 5 6 #f) #t)
   '((1 2 #f 3 4) (5 6 #f))
   "Should work with boolean separators"))
