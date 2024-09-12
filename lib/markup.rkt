#lang pollen/mode racket
(require txexpr threading pollen/decode "markup/inlines.rkt" "markup/blocks.rkt")
(provide decode-markup)

(define/contract (decode-markup expr)
  (-> txexpr-elements? txexpr-elements?)
  (~> expr
      (decode-elements #:txexpr-elements-proc decode-blocks)
      (decode-elements #:string-proc decode-strong-emphases)
      (decode-elements #:string-proc decode-emphases)))

(module+ test
  (require rackunit)
  (test-case
   "decode-markup decodes markdown-style headings"
   (define markup ◊list{
 # Heading 1

 ## Heading 2

 ### Heading 3
 })
   (check-equal? (decode-markup markup) '((h1 "Heading 1") (h2 "Heading 2") (h3 "Heading 3"))))

  (test-case
   "decode-markup decodes markdown-style headings"
   (define markup ◊list{
 # Heading with *emphasis*

 Paragraph with *emphasis*.

 Paragraph with **strong emphasis**.
 })
   (check-equal?
    (decode-markup markup)
    '((h1 "Heading with " (em "emphasis"))
      (p "Paragraph with " (em "emphasis") ".")
      (p "Paragraph with " (strong "strong emphasis") "."))))

  (test-case
   "decode-markup decodes markdown-style horizontal rules"
   (define markup ◊list{
 Paragraph 1

 ---

 Paragraph 2

 ***

 Paragraph 3
 })
   (check-equal?
    (decode-markup markup)
    '((p "Paragraph 1")
      (hr)
      (p "Paragraph 2")
      (hr)
      (p "Paragraph 3"))))

  (test-case
   "decode-markup decodes combined markdown-style markup."
   (define markup ◊list{
 # Heading

 Simple paragraph.

 ## Subheading with *emphasis*

 This is paragraph with *emphasis* and also **strong emphasis**.

 ***

 This paragraph is after separator.
 })
   (check-equal?
    (decode-markup markup)
    '((h1 "Heading")
      (p "Simple paragraph.")
      (h2 "Subheading with " (em "emphasis"))
      (p
       "This is paragraph with "
       (em "emphasis")
       " and also "
       (strong "strong emphasis")
       ".")
      (hr)
      (p "This paragraph is after separator.")))))
