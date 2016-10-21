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
   (λ (function!)
     [thread (λ () [apply function! args])])
   flist))

(define-syntax-rule
  (fp_text str (at x y))
  (λ (side dc)
    (send dc set-scale 1 1)
    (if [eq? side 'top]
      (send dc set-text-foreground "blue")
      (send dc set-text-foreground "red"))
    (send dc draw-text str x y)))

(define (draw layer items ...)
  (λ (dc) (execute-functions (list items ...) (if [eq? layer 'F.Cu] 'top 'bottom) dc)))

(define-syntax module
  (syntax-rules ()
    [(module name (layer l) (tedit t) items ...)
      (draw l items ...)]
    [(module name (layer l) items ...)
      (draw l items ...)]))

(provide-symbols F.Cu B.Cu)
(provide fp_text module)
