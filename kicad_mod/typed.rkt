#lang typed/racket
(require/typed racket/undefined
               [undefined Any])

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

(define-syntax-rule (define-formal f)
  (define f (lambda arguments `(f ,@arguments))))


(define-typed-kicad fp_line String (Listof Any))

(define-typed at (Number Number) (Number))

(kicad-expand (for/list ([i (range 5)]) (fp_line "" (at i 2.0))))
