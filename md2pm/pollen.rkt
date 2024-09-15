#lang racket
(require "md2pm.rkt")
(provide txexpr->pm)

(module setup racket/base
  (require pollen/setup)
  (provide (all-defined-out))
  (define poly-targets '(html out)))
