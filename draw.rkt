#lang racket/gui

(define (execute-functions flist args)
  (for-each
   (lambda (function)
     [thread (lambda ()
        [if (void? function) void (function args)])])
   flist))

(define-syntax-rule
  (fp_text str (at x y))
  (lambda (dc)
    (send dc set-scale 1 1)
    (send dc set-text-foreground "blue")
    (send dc draw-text str x y)))

(define-syntax-rule
  (module items)
  (lambda (dc) (execute-functions items dc)))

(define my-module
  (module (list (fp_text "hi" (at 1 1)) (fp_text "lo" (at 20 20)))))

(define frame (new frame%
                   [label "Example"]
                   [width 300]
                   [height 300]))
(new canvas% [parent frame]
             [paint-callback (lambda (canvas dc) (my-module dc))])
(send frame show #t)