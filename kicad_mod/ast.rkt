#lang racket

(require "provide-symbols.rkt")

(provide-symbols F.Cu B.Cu)

(provide
 (contract-out
  (width (-> number? width?))
  (layer (-> symbol? layer?))
  (end (-> number? number? end?))
  (start (-> number? number? start?))
  (fp_line (-> start? end? layer? width? fp_line?))))


(struct width (w) #:transparent)
(struct layer (l) #:transparent)
(struct end (x y) #:transparent)
(struct start (x y) #:transparent)
(struct fp_line (start end layer width) #:transparent)
