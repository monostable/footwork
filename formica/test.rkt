#lang racket
(require "formal.rkt" (only-in define-formal))

(define-formal f)

(displayln (f 'x))
