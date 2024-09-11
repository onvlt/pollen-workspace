#lang pollen/mode racket
(require threading txexpr pollen/decode)
(provide txexpr->plain txexpr->ctx)

(define (txexpr->plain elements)
  (any/c . -> . string?)
  (apply string-append (filter string? (flatten elements))))

(define (encode-inlines expr)
  (case (get-tag expr)
    [(em) (format "{\\em ~a}" (txexpr->plain expr))]
    [(strong) (format "{\\bf ~a}" (txexpr->plain expr))]
    [(col) " \\NC "]
    [else expr]))

(define (encode-blocks expr)
  (case (get-tag expr)
    [(p) (format "~a\n\n" (txexpr->plain expr))]
    [(h1) (format "\\chapter{~a}\n\n" (txexpr->plain expr))]
    [(h2) (format "\\section{~a}\n\n" (txexpr->plain expr))]
    [(h3) (format "\\subsection{~a}\n\n" (txexpr->plain expr))]
    [(li) (format "\\item ~a\n" (txexpr->plain expr))]
    [(ul) (format "\\startitemize\n~a\\stopitemize\n\n" (txexpr->plain expr))]
    [(ol) (format "\\startitemize[n]\n~a\\stopitemize\n\n" (txexpr->plain expr))]
    [(hr) (format "***\n\n")]
    [(table) (render-table expr)]
    [(row) (format "~a \\AR\n" (txexpr->plain expr))]
    [else expr]))

(define (render-table content)
  ◊list{
 \startplacetable[location=here,number=no]
 \starttabulate
 ◊(txexpr->plain content)\stoptabulate
 \stopplacetable})

(define (txexpr->ctx . elements)
  (~> elements
      (decode-elements
       #:inline-txexpr-proc encode-inlines
       #:block-txexpr-proc encode-blocks)
      (txexpr->plain)
      (string-trim)))
