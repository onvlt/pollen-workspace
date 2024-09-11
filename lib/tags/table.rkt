#lang pollen/mode racket
(require txexpr pollen/decode "../markup/utils.rkt")
(provide table)

(define (table . elements)
  (txexpr 'table empty (decode-table elements)))

(define (decode-table-row elements)
  (define (string-proc str)
    (map-matches #rx" +\\| +" str (λ (_) (txexpr 'col empty empty))))
  (txexpr 'row empty (decode-elements elements #:string-proc string-proc)))

(define (decode-table elements)
  (decode-elements
   elements
   #:txexpr-elements-proc
   (λ (elements) (decode-paragraphs elements decode-table-row))))

(module+ test
  (require rackunit)
  (test-case
   "decode-table decodes paragraphs as table rows and columns"
   (check-equal? (decode-table ◊list{
 Lorem | Ipsum | Dolor

 Sit | Amet | Consecteur
 }) '((row "Lorem" (col) "Ipsum" (col) "Dolor") (row "Sit" (col) "Amet" (col) "Consecteur")))))
