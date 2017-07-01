#lang racket
(require racket/serialize)
(require "ast.rkt")

(define (flatten/list lst)
  (foldl
   (lambda (x result)
     (if (list? x)
         (append result (flatten/list x))
         (append result (list x))))
   (list)
   lst))

(define (to-vector x)
  (let* ([v (struct->vector x)]
         [s (de-struct (vector-ref v 0))])
    (begin
      (vector-set! v 0 s)
      (vector->immutable-vector v))))

(define (to-list x)
  (let* ([v (struct->vector x)]
         [s (de-struct (vector-ref v 0))])
    (begin
      (vector-set! v 0 s)
      (vector->list v))))

(define (de-struct symbol)
  (let ([str (symbol->string symbol)])
    (string->symbol
     (string-replace str "struct:" ""))))

(define m
  (module "" (layer F.Cu)
    (for/list
      ([i (range 5)])
      (for/list
        ([j (range 5)])
        (fp_line (start i 1.0) (end j 2.0) (layer F.Cu) (width 1.0))))))

(pretty-print (flatten/list (to-list m)))
