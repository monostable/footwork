#lang racket
;(define-syntax [at x y] [at x y z]

(define-syntax-rule
  (swap x y)
  (let ([tmp x])
    (set! x y)
    (set! y tmp)))

(define-syntax rotate
  (syntax-rules ()
    [(rotate a b) (swap a b)]
    [(rotate a b c) (begin
                      (swap a b)
                      (swap b c))]))

;(define syntax at
;  (syntax-rules ()
;   [(at x y) (

;(let ([red 1] [greel 2] [blue 3])
;  (rot