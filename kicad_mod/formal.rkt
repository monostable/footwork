#lang racket

(define-syntax-rule (define-formal f)
  (define f (lambda arguments (quasiquote (f (unquote-splicing arguments))))))

(provide define-formal)
