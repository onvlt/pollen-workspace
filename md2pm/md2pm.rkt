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


(define (encode-tag expr #:wrap-content-with-newlines? [wrap-content-with-newlines? #f])
  (define attrs (get-attrs expr))
  (define elements (get-elements expr))
  (define tag-str (format "◊~a" (get-tag expr)))
  (define attrs-str
    (cond [(empty? attrs) #f]
          [else (format "[~a]" (encode-attrs attrs))]))
  (define elements-str
    (cond [wrap-content-with-newlines? (format "{\n~a\n}" (apply string-append elements))]
          [else (format "{~a}" (apply string-append elements))]))

  (apply string-append (filter identity (list tag-str attrs-str elements-str))))

(define/contract (encode-txexpr expr)
  (-> txexpr? any/c)
  (define-values (tag attrs elements) (values (get-tag expr) (get-attrs expr) (get-elements expr)))
  (cond
    [(regexp-match? #rx"^temp-" (symbol->string tag)) expr]
    [(eq? tag 'root) (apply string-append elements)]
    ((eq? tag 'p) (apply string-append elements))
    ((eq? tag 'h1) (encode-tag (txexpr 'chapter attrs elements)))
    ((eq? tag 'h2) (encode-tag (txexpr 'section attrs elements)))
    ((eq? tag 'h3) (encode-tag (txexpr 'subsection attrs elements)))
    ((eq? tag 'ul) (encode-tag (txexpr 'bullet-list attrs elements) #:wrap-content-with-newlines? #t))
    ((eq? tag 'ol) (encode-tag (txexpr 'number-list attrs elements) #:wrap-content-with-newlines? #t))
    ((eq? tag 'li) (apply string-append (cons "◊(item) " elements)))
    [#t (encode-tag expr)]))

(define (intersperse-newlines elements)
  (intersperse elements block-txexpr? "\n\n"))

(define (txexpr->pm . elements)
  (~> elements
      (decode-elements #:txexpr-elements-proc intersperse-newlines)
      (decode-elements #:txexpr-proc encode-txexpr
                       #:txexpr-elements-proc encode-elements)))
