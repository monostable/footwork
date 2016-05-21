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

(provide (except-out (all-from-out racket) #%module-begin)
         (rename-out [module-begin #%module-begin]))

(define-syntax-rule (module-begin expr ...)
  (#%module-begin
   (provide-symbols F.Cu B.Cu)))