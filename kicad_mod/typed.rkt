#lang typed/racket
(require/typed racket/undefined
               [undefined Any])

(require (for-syntax syntax/parse))

(struct kicad ([expr : (Listof Any)]))

(define (kicad->list expr)
  (match expr
    [(kicad (list e ...)) `(,@e)]))

(: kicad-expand ((Listof Any) -> (Listof Any)))
(define (kicad-expand e)
  (map kicad->list
    (flatten e)))


(define-syntax-rule (define-typed-kicad f argument-types ...)
  (begin
    (: f (argument-types ... -> kicad))
    (define f (lambda arguments (kicad `(f ,@arguments))))))

(define-syntax define-typed
  (syntax-rules ()
    [(define-typed f (argument-types ...) (optional-types ...))
     (begin
       (: f (->* (argument-types ...) (optional-types ...) (Listof Any)))
       (define f (lambda arguments `(f ,@arguments))))]
    [(define-typed f (argument-types ...))
     (define-typed f (argument-types ...) ())]))

(define-typed at (Number Number) (Number))

(: unless-equals (Any Any -> (Listof Any)))
(define (unless-equals test value)
  (filter (lambda (x) (not (eq? (void) x))) (list (unless (eq? test value) value))))

(define-syntax (fp_text stx)
  (syntax-parse stx
    [(fp_text str (at x y (~optional o #:defaults ([o #'0]))))
     #'(kicad `(fp_text ,str (at ,x ,y ,@(unless-equals 0 o))))]))

(pretty-print
  (kicad-expand
    (for/list ([i (range 5)]) (fp_text "" (at 0 2.0 i)))))
