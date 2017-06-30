#lang racket

(require "ast.rkt")

(width 1.0)

(layer F.Cu)

(end 5.0 1.0)

(for/list
  ([i (range 5)])
  (fp_line (start i 1.0) (end 0.0 2.0) (layer F.Cu) (width 1.0)))

