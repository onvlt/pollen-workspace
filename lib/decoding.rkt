#lang pollen/mode racket
(require txexpr threading pollen/decode)
(provide decode-markup decode-list-items decode-table)

; Apply given `proc` to all matches of `pat` regex pattern in `str`.
; Proc accepts matched string as first argument and variablue number of rest arguments,
; which corresponds to the number of capture groups, otherwise you get
; arity mismatch error. Must return `txexpr-element?`
(define/contract (transform-matches pat str proc)
  (-> regexp? string? procedure? txexpr-elements?)
  (define sections (regexp-match* pat str #:match-select values #:gap-select? #t))
  (filter-map
   (λ (section)
     (match section
       [(list matches ...) (apply proc matches)]
       ["" #f]
       [other other])) sections))

(define/contract (decode-emphases str)
  (-> string? txexpr-elements?)
  (transform-matches
   #rx"\\*(.+?)\\*" str
   (λ (_ content) (txexpr 'em empty (list content)))))

(define/contract (decode-strong-emphases str)
  (-> string? txexpr-elements?)
  (transform-matches
   #rx"\\*\\*(.+?)\\*\\*" str
   (λ (_ content) (txexpr 'strong empty (list content)))))

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

(define/contract (decode-markup expr)
  (-> txexpr-elements? txexpr-elements?)
  (~> expr
      (decode-elements #:txexpr-elements-proc decode-blocks)
      (decode-elements #:string-proc decode-strong-emphases)
      (decode-elements #:string-proc decode-emphases)))

(define/contract (decode-list-items elements)
  (-> txexpr-elements? txexpr-elements?)
  (decode-elements
   elements
   #:txexpr-elements-proc
   (λ (elements) (decode-paragraphs elements 'li))))

(define (decode-table-row elements)
  (define (string-proc str)
    (transform-matches #rx" +\\| +" str (λ (_) (txexpr 'col empty empty))))
  (txexpr 'row empty (decode-elements elements #:string-proc string-proc)))

(define/contract (decode-table elements)
  (-> txexpr-elements? txexpr-elements?)
  (decode-elements
   elements
   #:txexpr-elements-proc
   (λ (elements) (decode-paragraphs elements decode-table-row))))

(module+ test
  (require rackunit)

  (test-case
   "transform-matches transforms matched patterns with given procedure"
   (check-equal?
    (transform-matches #px"[A-Z]{3,}" "lorem IPSUM dolor sit AMET consecteur" identity)
    '("lorem " "IPSUM" " dolor sit " "AMET" " consecteur"))
   (check-equal?
    (transform-matches #px"[A-Z]{3,}" "lorem IPSUM dolor sit AMET consecteur" string-downcase)
    '("lorem " "ipsum" " dolor sit " "amet" " consecteur"))
   (check-equal?
    (transform-matches #rx"_(.+?)_" "lorem _ipsum_ dolor" (λ (_ content) content))
    '("lorem " "ipsum" " dolor"))
   (check-equal?
    (transform-matches #rx"_(.+?)_" "lorem _ipsum_ dolor" (λ (_ content) (string-upcase content)))
    '("lorem " "IPSUM" " dolor"))
   (check-equal?
    (transform-matches #rx"_(.+?)_" "lorem _ipsum_ dolor" (λ (_ content) (txexpr 'em empty (list content))))
    '("lorem " (em "ipsum") " dolor")))

  (test-case
   "transform-matches does not output trailing or trailing empty strings"
   (check-equal?
    (transform-matches #rx"\\*(.+?)\\*" "Lorem ipsum *dolor*" (λ (_ content) content))
    '("Lorem ipsum " "dolor"))
   (check-equal?
    (transform-matches #rx"\\*(.+?)\\*" "*Lorem* ipsum dolor" (λ (_ content) content))
    '("Lorem" " ipsum dolor")))

  (test-case
   "decode-emphases decodes markdown-style emphases"
   (check-equal? (decode-emphases "This is *emphasis*.") '("This is " (em "emphasis") "."))
   (check-equal? (decode-emphases "*This* is emphasis.") '((em "This") " is emphasis."))
   (check-equal? (decode-emphases "This *is really* emphasis.") '("This " (em "is really") " emphasis.")))

  (test-case
   "decode-emphases decodes markdown-style strong emphases"
   (check-equal? (decode-strong-emphases "This is **emphasis**.") '("This is " (strong "emphasis") "."))
   (check-equal? (decode-strong-emphases "**This** is emphasis.") '((strong "This") " is emphasis."))
   (check-equal? (decode-strong-emphases "This **is really** emphasis.") '("This " (strong "is really") " emphasis.")))

  (test-case
   "decode-markup decodes markdown-style headings"
   (check-equal? (decode-markup ◊list{
 # Heading 1

 ## Heading 2

 ### Heading 3
 }) '((h1 "Heading 1") (h2 "Heading 2") (h3 "Heading 3"))))

  (test-case
   "decode-markup decodes markdown-style headings"
   (check-equal? (decode-markup ◊list{

 # Heading with *emphasis*

 Paragraph with *emphasis*.

 Paragraph with **strong emphasis**.

 }) '((h1 "Heading with " (em "emphasis"))
      (p "Paragraph with " (em "emphasis") ".")
      (p "Paragraph with " (strong "strong emphasis") "."))))

  (test-case
   "decode-markup decodes markdown-style horizontal rules"
   (check-equal? (decode-markup ◊list{
 Paragraph 1

 ---

 Paragraph 2

 ***

 Paragraph 3
 }) '(
      (p "Paragraph 1")
      (hr)
      (p "Paragraph 2")
      (hr)
      (p "Paragraph 3")
      )))

  (test-case
   "decode-markup decodes combined markdown-style markup."
   (check-equal? (decode-markup ◊list{
 # Heading

 Simple paragraph.

 ## Subheading with *emphasis*

 This is paragraph with *emphasis* and also **strong emphasis**.

 ***

 This paragraph is after separator.
 }) '(
      (h1 "Heading")
      (p "Simple paragraph.")
      (h2 "Subheading with " (em "emphasis"))
      (p
       "This is paragraph with "
       (em "emphasis")
       " and also "
       (strong "strong emphasis")
       ".")
      (hr)
      (p "This paragraph is after separator."))))

  (test-case
   "decode-list-items decodes paragraphs as list items"
   (check-equal? (decode-list-items ◊list{
 Lorem

 Ipsum

 Dolor
 }) '((li "Lorem") (li "Ipsum") (li "Dolor"))))

  (test-case
   "decode-table decodes paragraphs as table rows and columns"
   (check-equal? (decode-table ◊list{
 Lorem | Ipsum | Dolor

 Sit | Amet | Consecteur
 }) '((row "Lorem" (col) "Ipsum" (col) "Dolor") (row "Sit" (col) "Amet" (col) "Consecteur")))))
