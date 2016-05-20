#lang racket/gui

(define (execute-functions flist . args)
  (for-each
   (lambda (function)
     [thread (lambda ()
        [apply function args])])
   flist))

(define-syntax-rule
  (fp_text str (at x y))
  (lambda (dc)
    (send dc set-scale 1 1)
    (send dc set-text-foreground "blue")
    (send dc draw-text str x y)))

(define-syntax-rule
  (module name (layer l) (tedit t) items ...)
  (lambda (dc) (execute-functions (list items ...) dc)))

(define my-module
  (module Neosid_Air-Coil_SML_1turn_HDM0131A (layer F.Cu) (tedit 56CA2F43)
    (fp_text "hi" (at 1 1)) (fp_text "lo" (at 20 20))))

(define frame (new frame%
                   [label "Example"]
                   [width 300]
                   [height 300]))
(new canvas% [parent frame]
             [paint-callback (lambda (canvas dc) (my-module dc))])
(send frame show #t)