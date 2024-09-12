#lang racket
(require txexpr "utils.rkt")
(provide decode-emphases decode-strong-emphases)

(define/contract (decode-emphases str)
  (-> string? txexpr-elements?)
  (map-matches
   #rx"\\*(.+?)\\*" str
   (λ (_ content) (txexpr 'em empty (list content)))))

(define/contract (decode-strong-emphases str)
  (-> string? txexpr-elements?)
  (map-matches
   #rx"\\*\\*(.+?)\\*\\*" str
   (λ (_ content) (txexpr 'strong empty (list content)))))

(module+ test
  (require rackunit)

  (test-case
   "decode-emphases decodes markdown-style emphases"
   (check-equal? (decode-emphases "This is *emphasis*.") '("This is " (em "emphasis") "."))
   (check-equal? (decode-emphases "*This* is emphasis.") '((em "This") " is emphasis."))
   (check-equal? (decode-emphases "This *is really* emphasis.") '("This " (em "is really") " emphasis.")))

  (test-case
   "decode-strong-emphases decodes markdown-style strong emphases"
   (check-equal? (decode-strong-emphases "This is **emphasis**.") '("This is " (strong "emphasis") "."))
   (check-equal? (decode-strong-emphases "**This** is emphasis.") '((strong "This") " is emphasis."))
   (check-equal? (decode-strong-emphases "This **is really** emphasis.") '("This " (strong "is really") " emphasis."))))
