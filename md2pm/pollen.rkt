#lang racket
(require "md2pm.rkt")
(provide txexpr->pm)

(module setup racket/base
  (require pollen/setup)
  (provide (all-defined-out))
  (define block-tags (append default-block-tags '(row bullet-list number-list item chapter section subsection)))
  (define poly-targets '(html out)))
