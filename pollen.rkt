#lang racket
(require txexpr pollen/core "lib/markup.rkt" "lib/tags/table.rkt" "lib/tags/lists.rkt")
(provide current-lang current-author root bullet-list number-list table)

(define default-author "Ondřej Nývlt")
(define default-lang "cs")

(module setup racket/base
  (require pollen/setup)
  (provide (all-defined-out))
  (define block-tags (append default-block-tags '(row)))
  (define poly-targets '(html ctx)))

(define/contract (current-lang)
  (-> string?)
  (or (select 'lang (current-metas)) default-lang))

(define/contract (current-author)
  (-> string?)
  (or (select 'author (current-metas)) default-author))

(define (root . elements)
  (txexpr 'root empty (decode-markup elements)))



