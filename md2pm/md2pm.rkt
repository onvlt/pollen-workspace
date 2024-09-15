#lang racket
(require pollen/decode txexpr threading "list-utils.rkt")
(provide txexpr->pm)

(define (encode-elements elements)
  (apply string-append
         (map (λ (elem) (format "~a" elem)) elements)))

(define (encode-attrs attrs)
  (apply string-append
         (map (λ (item)
                (match-define (list key value) item)
                (format "#:~a ~a" key value)) attrs)))

(define (encode-tag expr)
  (define-values (tag attrs elements) (values (get-tag expr) (get-attrs expr) (get-elements expr)))
  (define tag-str (format "◊~a" tag))
  (define attrs-str
    (cond [(empty? attrs) #f]
          [else (string-append "[" (encode-attrs attrs) "]")]))
  (define elements-str (string-append "{" (encode-elements elements) "}"))
  (apply string-append (filter identity (list tag-str attrs-str elements-str))))

(define/contract (encode-txexpr expr)
  (-> txexpr? any/c)
  (define-values (tag attrs elements) (values (get-tag expr) (get-attrs expr) (get-elements expr)))
  (cond
    [(regexp-match? #rx"^temp-" (symbol->string tag)) expr]
    [(eq? tag 'root) (encode-elements elements)]
    ((eq? tag 'p) (encode-elements elements))
    ((eq? tag 'h1) (encode-tag (txexpr 'chapter attrs elements)))
    ((eq? tag 'h2) (encode-tag (txexpr 'section attrs elements)))
    ((eq? tag 'h3) (encode-tag (txexpr 'subsection attrs elements)))
    ((eq? tag 'ul) (encode-tag (txexpr 'bullet-list attrs elements)))
    ((eq? tag 'ol) (encode-tag (txexpr 'number-list attrs elements)))
    ; ((eq? tag 'li) (encode-tag (txexpr 'item attrs elements)))
    ((eq? tag 'li) (encode-elements (cons "◊(item) " elements)))
    [#t (encode-tag expr)]))

(define (intersperse-newlines elements)
  (intersperse elements block-txexpr? "\n\n"))

(define (wrap-block-contents expr)
  (define-values (tag attrs elements) (values (get-tag expr) (get-attrs expr) (get-elements expr)))
  (define wrap-content-with-newlines? (ormap block-txexpr? elements))
  (define new-elements (cond [wrap-content-with-newlines? (append (list "\n") elements (list "\n"))]
                             [else elements]))
  (txexpr tag attrs new-elements))

(define (txexpr->pm . elements)
  (~> elements
      (decode-elements #:txexpr-elements-proc intersperse-newlines)
      (decode-elements #:txexpr-proc wrap-block-contents)
      (decode-elements #:txexpr-proc encode-txexpr)))
