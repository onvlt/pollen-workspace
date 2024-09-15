#lang racket
(require pollen/decode txexpr threading)
(provide txexpr->pm)

; (define (txexpr->plain elements)
;   (apply string-append (filter string? (flatten elements))))

(define (encode-elements elements)
  (define fmt-elements (map (λ (elem) (format "~a" elem)) elements))
  (format "{~a}" (apply string-append fmt-elements)))

(define (encode-attrs attrs)
  (~> attrs
      (map (λ (item)
             (match-define (list key value) item)
             (format "#:~a ~a" key value)) _)
      (string-join " " #:before-first "[" #:after-last "]")))

(define/contract (encode-tag expr)
  (-> txexpr? string?)
  (define tag (get-tag expr))
  (define attrs (get-attrs expr))
  (define elements (get-elements expr))

  (define tag-str (format "◊~a" (get-tag expr)))
  (define attrs-str
    (cond [(empty? attrs) #f]
          [else (encode-attrs attrs)]))
  (define elements-str (encode-elements elements))

  (apply string-append (filter identity (list tag-str attrs-str elements-str))))

(define/contract (encode-txexpr expr)
  (-> txexpr? any/c)
  (define tag (get-tag expr))
  (cond
    [(regexp-match? #rx"^temp-" (symbol->string tag)) expr]
    [(eq? tag 'root) (apply string-append (get-elements expr))]
    ; ((eq? tag 'p) (apply string-append (get-elements expr)))
    [(block-txexpr? expr) (string-append (encode-tag expr) "\n\n")]
    [#t (encode-tag expr)]))

(define (txexpr->pm . elements)
  (decode-elements elements #:txexpr-proc encode-txexpr))
