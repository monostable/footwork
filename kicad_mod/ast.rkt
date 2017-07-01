#lang racket

(require "provide-symbols.rkt")
(require "formal.rkt")

(require (only-in racket (for for/effect) (for/list for)))

(provide-symbols F.Cu B.Cu)

(provide
 (contract-out
  (width (-> number? width?))
  (layer (-> symbol? layer?))
  (end (-> number? number? end?))
  (start (-> number? number? start?))
  (fp_line (-> start? end? layer? width? fp_line?))))

(provide module for)


(struct width (w) #:transparent)
(struct end (x y) #:transparent)
(struct start (x y) #:transparent)
(struct fp_line (start end layer width) #:transparent)
(struct module (name layer exprs) #:transparent)

;(define module
;  (lambda (name layer expr . exprs)
;    (module name layer (list expr exprs)))


(struct layer (l)
 #:methods gen:custom-write
    [(define (write-proc layer port mode)
      (write-string (~a "(layer " (layer-l layer) ")") port))])
