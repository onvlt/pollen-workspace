#lang racket
(require txexpr pollen/core "lib/decoding.rkt")
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

(define (bullet-list . elements)
  (txexpr 'ul empty (decode-list-items elements)))

(define (number-list . elements)
  (txexpr 'ol empty (decode-list-items elements)))

(define (table . elements)
  (txexpr 'table empty (decode-table elements)))
