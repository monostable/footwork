#lang racket
(require (only-in racket (for for/effect) (for/list for)))
(require "provide-symbols.rkt")

(define (execute-functions flist . args)
  (for-each
   (λ (function!)
     [thread (λ () [apply function! args])])
   flist))


(define-syntax-rule
  (fp_text str (at x y))
  (λ (side dc)
    (if [eq? side 'top]
      (send dc set-text-foreground "blue")
      (send dc set-text-foreground "red"))
    (send dc draw-text str x y)))


(define-syntax-rule
  (fp_line (start start-x start-y) (end end-x end-y) (layer l) (width w))
  (λ (side dc)
    (send dc set-pen "darkred" w 'solid)
    (send dc draw-line start-x start-y end-x end-y)))


(define (draw layer . items)
  (λ (dc)
    (send dc set-scale 10 10)
    (execute-functions
      (flatten items) (if [eq? layer 'F.Cu] 'top 'bottom) dc)))


(define-syntax module
  (syntax-rules ()
    [(module name (layer l) (tedit t) items ...)
      (draw l items ...)]
    [(module name (layer l) items ...)
      (draw l items ...)]))


(provide-symbols F.Cu B.Cu)
(provide fp_text fp_line module for)
