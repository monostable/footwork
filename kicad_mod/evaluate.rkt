#lang racket
(require (only-in racket (for for/effect) (for/list for)))
(require "provide-symbols.rkt")

(define key-words '())

;macro to define kicad expressions as quoted versions of themselves
(define-syntax-rule (kicad-define f)
  (begin
    (define f (lambda arguments (quasiquote (f (unquote-splicing arguments)))))
    (set! key-words (append key-words '(f)))))


(kicad-define fp_line)
(kicad-define fp_text)
(kicad-define start)
(kicad-define at)
(kicad-define end)
(kicad-define layer)
(kicad-define width)
(kicad-define tedit)


;(define patterns (map (lambda (word) `(list ',word _ ...)) key-words))

(define patterns '('(x _ ...)))


(println patterns)

(define (kicad-expr? expr)
  (match expr
    [(or patterns) #t]))

(println (kicad-expr? 'fp_lie))

(define module
  (lambda arguments (quasiquote (module (unquote-splicing arguments)))))

(provide-symbols F.Cu B.Cu)
(provide fp_text fp_line start at end layer width tedit module for)
