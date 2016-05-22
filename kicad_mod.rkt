#lang racket
(require (for-syntax syntax/parse))

(define-syntax (provide-symbols stx)
  (syntax-parse stx
    [(_define-symbols id:id ...)
     (syntax/loc stx
       (begin
         (begin (define id 'id)
         (provide id))
         ...))]
    [_ (raise-syntax-error 'define-symbols
                           "Expected (define-symbols <identifier> ...)"
                           stx)]))

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
  (lambda (dc) (execute-functions (list items ...) (if [eq? _layer 'F.Cu] 'top 'bottom) dc)))

(provide-symbols F.Cu B.Cu)
(provide fp_text module)
