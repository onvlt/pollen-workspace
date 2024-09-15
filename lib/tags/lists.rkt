#lang pollen/mode racket
(require txexpr racket/string "./list-utils.rkt")
(provide bullet-list number-list)

(define (bullet-list . elements)
  (txexpr 'ul empty (decode-list-items elements)))

(define (number-list . elements)
  (txexpr 'ol empty (decode-list-items elements)))

(define/contract (trim-leading-whitespace elements)
  (-> txexpr-elements? txexpr-elements?)
  (cond
    [(empty? elements) empty]
    [else
     (define first-element (car elements))
     (cond
       [(string? first-element)
        (define trimmed-first-element (string-trim first-element #:left? #t #:right? #f))
        (cond
          [(non-empty-string? trimmed-first-element)
           (cons trimmed-first-element (cdr elements))]
          [else (cdr elements)])]
       [else elements])]))

(define (decode-list-items elements)
  (define list-items (split-by-separator elements '(item)))
  (map (λ (content) (txexpr 'li empty (trim-leading-whitespace content))) list-items))

(module+ test
  (require rackunit)

  (check-equal? (trim-leading-whitespace '()) '())
  (check-equal? (trim-leading-whitespace '("Lorem")) '("Lorem"))
  (check-equal? (trim-leading-whitespace '("Lorem ipsum ")) '("Lorem ipsum "))
  (check-equal? (trim-leading-whitespace '("Lorem" "ipsum ")) '("Lorem" "ipsum "))
  (check-equal? (trim-leading-whitespace '(" Lorem")) '("Lorem"))
  (check-equal? (trim-leading-whitespace '(" Lorem" "ipsum")) '("Lorem" "ipsum"))
  (check-equal? (trim-leading-whitespace '(" " (em "Lorem") "ipsum")) '((em "Lorem") "ipsum")))
