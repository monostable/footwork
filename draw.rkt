#lang racket
(require racket/gui)
(require (for-syntax syntax/parse))

(define-syntax (define-symbols stx)
  (syntax-parse stx
    [(_define-symbols id:id ...)
     (syntax/loc stx
       (begin
         (define id 'id)
         ...))]
    [_ (raise-syntax-error 'define-symbols
                           "Expected (define-symbols <identifier> ...)"
                           stx)]))

(define sides '(top bottom))
(define-symbols F.Cu B.Cu)

(define (execute-functions flist . args)
  (for-each
   (lambda (function!)
     [thread (lambda ()
        [apply function! args])])
   flist))

(define-syntax-rule
  (fp_text str (at x y))
  (lambda (side dc)
    (send dc set-scale 1 1)
    (if [eq? side 'top]
      (send dc set-text-foreground "blue")
      (send dc set-text-foreground "red"))
    (send dc draw-text str x y)))

(define-syntax-rule
  (module name (layer _layer) (tedit t) items ...)
  (lambda (dc) (execute-functions (list items ...) (if [eq? _layer F.Cu] 'top 'bottom) dc)))

(define my-module
  (module Neosid_Air-Coil_SML_1turn_HDM0131A (layer B.Cu) (tedit 56CA2F43)
    (fp_text "hi" (at 1 1)) (fp_text "lo" (at 20 20))))

(define frame (new frame%
                   [label "Example"]
                   [width 300]
                   [height 300]))
(new canvas% [parent frame]
             [paint-callback (lambda (canvas dc) (my-module dc))])
(send frame show #t)
