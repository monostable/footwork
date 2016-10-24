#lang racket
(require "../formica/formal.rkt")
(require (only-in racket (for for/effect) (for/list for)))
(require "provide-symbols.rkt")

(define-formal fp_line)
(define-formal fp_text)
(define-formal start)
(define-formal at)
(define-formal end)
(define-formal layer)
(define-formal width)
(define-formal tedit)
(define-formal module)

(provide-symbols F.Cu B.Cu)
(provide fp_text fp_line start at end layer width tedit module for)

;(println
;  (~s
;      (module "" (layer B.Cu)
;        (fp_line (start 0 0) (end 5 5) (layer F.Cu) (width 10))
;        (for ([i (range 0 6 2)] [w '("oh" "la" "lah")])
;          (fp_text w (at 1 i)))))
