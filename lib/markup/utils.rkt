#lang racket
(require txexpr)
(provide map-matches)

; Apply given `proc` to all matches of `pat` regex pattern in `str`.
; Proc accepts matched string as first argument and variablue number of rest arguments,
; which corresponds to the number of capture groups, otherwise you get
; arity mismatch error. Must return `txexpr-element?`
(define/contract (map-matches pat str proc)
  (-> regexp? string? procedure? txexpr-elements?)
  (define sections (regexp-match* pat str #:match-select values #:gap-select? #t))
  (filter-map
   (λ (section)
     (match section
       [(list matches ...) (apply proc matches)]
       ["" #f]
       [other other])) sections))

(module+ test
  (require rackunit)

  (test-case
   "map-matches transforms matched strings with given proc"
   (check-equal?
    (map-matches #px"[A-Z]{3,}" "lorem IPSUM dolor sit AMET consecteur" identity)
    '("lorem " "IPSUM" " dolor sit " "AMET" " consecteur"))
   (check-equal?
    (map-matches #px"[A-Z]{3,}" "lorem IPSUM dolor sit AMET consecteur" string-downcase)
    '("lorem " "ipsum" " dolor sit " "amet" " consecteur"))
   (check-equal?
    (map-matches #rx"_(.+?)_" "lorem _ipsum_ dolor" (λ (_ content) content))
    '("lorem " "ipsum" " dolor"))
   (check-equal?
    (map-matches #rx"_(.+?)_" "lorem _ipsum_ dolor" (λ (_ content) (string-upcase content)))
    '("lorem " "IPSUM" " dolor")))

  (test-case
   "map-matches wraps matches in x-expression with given proc"
   (check-equal?
    (map-matches #rx"_(.+?)_" "lorem _ipsum_ dolor" (λ (_ content) (txexpr 'em empty (list content))))
    '("lorem " (em "ipsum") " dolor")))

  (test-case
   "map-matches does not output trailing or trailing empty strings"
   (check-equal?
    (map-matches #rx"\\*(.+?)\\*" "Lorem ipsum *dolor*" (λ (_ content) content))
    '("Lorem ipsum " "dolor"))
   (check-equal?
    (map-matches #rx"\\*(.+?)\\*" "*Lorem* ipsum dolor" (λ (_ content) content))
    '("Lorem" " ipsum dolor"))))
