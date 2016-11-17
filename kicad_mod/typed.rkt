#lang typed/racket
(require/typed racket/undefined
               [undefined Any])

(struct kicad ([expr : (Listof Any)]))

(define (kicad->list expr)
  (match expr
    [(kicad (list e ...)) (quasiquote ((unquote-splicing e)))]))

(: kicad-expand (-> (Listof Any) (Listof Any)))
(define (kicad-expand e)
  (map kicad->list
    (flatten e)))


(define-syntax-rule (define-typed-kicad f argument-types ...)
  (begin
    (: f (argument-types ... -> kicad))
    (define f (lambda arguments (kicad (quasiquote (f (unquote-splicing arguments))))))))

(define-syntax-rule (define-typed f argument-types ...)
  (begin
    (: f (argument-types ... -> (Listof Any)))
    (define f (lambda arguments (quasiquote (f (unquote-splicing arguments)))))))

(define-syntax-rule (define-formal f)
  (define f (lambda arguments (quasiquote (f (unquote-splicing arguments))))))

(define-typed-kicad fp_line String (Listof Any))

(: at (->* (Number Number) (Number) (Listof Any)))
(define-formal at)

(kicad-expand (for/list ([i (range 5)]) (fp_line "" (at i 2.0 5))))
