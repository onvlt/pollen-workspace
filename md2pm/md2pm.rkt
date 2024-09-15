#lang racket
(require pollen/decode txexpr threading "list-utils.rkt")
(provide txexpr->pm)

(define (encode-elements elements)
  (map (λ (elem) (format "~a" elem)) elements))

(define (encode-attrs attrs)
  (apply string-append
         (map (λ (item)
                (match-define (list key value) item)
                (format "#:~a ~a" key value)) attrs)))

(define (encode-tag expr #:block? [block? #f])
  (define attrs (get-attrs expr))
  (define elements (get-elements expr))
  (define tag-str (format "◊~a" (get-tag expr)))
  (define attrs-str
    (cond [(empty? attrs) #f]
          [else (format "[~a]" (encode-attrs attrs))]))
  (define elements-str
    (cond [block? (format "{\n~a\n}" (apply string-append elements))]
          [else (format "{~a}" (apply string-append elements))]))

  (apply string-append (filter identity (list tag-str attrs-str elements-str))))

(define/contract (encode-txexpr expr)
  (-> txexpr? any/c)
  (define tag (get-tag expr))
  (cond
    [(regexp-match? #rx"^temp-" (symbol->string tag)) expr]
    [(eq? tag 'root) (apply string-append (get-elements expr))]
    ((eq? tag 'p) (apply string-append (get-elements expr)))
    [(member tag '(ul ol)) (encode-tag expr #:block? #t)]
    [#t (encode-tag expr)]))

(define (intersperse-newlines elements)
  (intersperse elements block-txexpr? "\n\n"))

(define (txexpr->pm . elements)
  (~> elements
      (decode-elements #:txexpr-elements-proc intersperse-newlines)
      (decode-elements #:txexpr-proc encode-txexpr
                       #:txexpr-elements-proc encode-elements)))
