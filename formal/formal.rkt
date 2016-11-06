#lang racket

(define-syntax-rule (define-formal f)
  (define-syntax-rule (f arguments (... ...))
     `(begin (define f #t) (f ,arguments (... ...)))))

(define-formal f)

(f 1)
; => '(f 1 2 3)

(map f '(1 2 3))
