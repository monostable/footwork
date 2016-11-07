#lang racket

(define-syntax-rule (define-formal f)
  (define f
    (lambda arguments
      (quasiquote (f (unquote-splicing arguments))))))

(define-formal f)

(define-formal g)

(f (g 1))

(f)

(map f '(1 2 (g 3)))

(foldl f 'x0 '(a b c))
