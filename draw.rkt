#lang racket/gui
;(define-syntax-rule
;  (at x y)
;  (cons x y)
;  )

(define-syntax-rule
  (fp_text str (at x y))
  (lambda (canvas dc)
    (send dc set-scale 1 1)
    (send dc set-text-foreground "blue")
    (send dc draw-text str x y)))

(define frame (new frame%
                   [label "Example"]
                   [width 300]
                   [height 300]))
(new canvas% [parent frame]
             [paint-callback (fp_text "hi" (at 1 1))])
(send frame show #t)