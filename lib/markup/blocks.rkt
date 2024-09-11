#lang racket
(require txexpr pollen/decode)
(provide decode-blocks)

(define (decode-block elements)
  (match (car elements)
    [(regexp #rx"^(#+) (.+)$" (list _ level-indent content))
     (define level (string-length level-indent))
     (define tag (format "h~a" level))
     (txexpr (string->symbol tag) empty (cons content (cdr elements)))]
    ["---" (txexpr 'hr empty empty)]
    ["***" (txexpr 'hr empty empty)]
    [_ (txexpr 'p empty elements)]))

(define/contract (decode-blocks elements)
  (-> txexpr-elements? txexpr-elements?)
  (decode-paragraphs elements decode-block))
