#lang pollen/mode racket
(require txexpr pollen/decode)
(provide bullet-list number-list)

(define (bullet-list . elements)
  (txexpr 'ul empty (decode-list-items elements)))

(define (number-list . elements)
  (txexpr 'ol empty (decode-list-items elements)))

(define (decode-list-items elements)
  (decode-elements elements #:txexpr-elements-proc (λ (elements) (decode-paragraphs elements 'li))))

(module+ test
  (require rackunit)

  (test-case
   "decode-list-items decodes paragraphs as list items"
   (check-equal? (decode-list-items ◊list{
 Lorem

 Ipsum

 Dolor
 }) '((li "Lorem") (li "Ipsum") (li "Dolor")))))
