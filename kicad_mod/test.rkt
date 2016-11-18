#lang typed/racket

(require "typed2.rkt")
(struct kicad ([expr : (Listof Any)]) #:transparent)

(define-syntax-rule (fp_text s at-expr)
  (kicad `(fp_text s ,at-expr)))

(fp_text Val** (at 1 2.0 180))