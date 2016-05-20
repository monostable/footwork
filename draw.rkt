#lang racket/gui
;(define-syntax-rule
;  (at x y)
;  (cons x y)
;  )

(define (apply-function-list flist element)
  (for-each (lambda (f)
         (thread (lambda () ((f element)))))
       flist))

(define-syntax-rule
  (fp_text str (at x y))
  (lambda (dc)
    (send dc set-scale 1 1)
    (send dc set-text-foreground "blue")
    (send dc draw-text str x y)))

(define-syntax-rule
  (module name (layer front-layer) (tedit time) items)
  (lambda (dc) (apply-function-list items dc)))

(define my-module
  (module "" (layer "") (tedit "") (list (fp_text "hi" (at 1 1)))))

(define frame (new frame%
                   [label "Example"]
                   [width 300]
                   [height 300]))
(new canvas% [parent frame]
             [paint-callback (lambda (canvas dc) (my-module dc))])
(send frame show #t)