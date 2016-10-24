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

(provide provide-symbols)
