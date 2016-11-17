#lang typed/racket
(require/typed racket/undefined
               [undefined Any])

(require "formal.rkt")

(define-syntax-rule (define-typed f argument-types ...)
  (begin
    (: f (argument-types ... -> (Listof Any)))
    (define f (lambda arguments (quasiquote (f (unquote-splicing arguments)))))))

(define-typed fp_line String String)

(fp_line "" "")
