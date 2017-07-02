#lang racket

(require "provide-symbols.rkt")
(require "formal.rkt")

(provide-symbols F.Cu B.Cu)

(provide
 (contract-out
  (width (-> number? width?))
  (layer (-> symbol? layer?))
  (end (-> number? number? end?))
  (start (-> number? number? start?))
  (fp_line (-> start? end? layer? width? fp_line?))))

(provide module)

(struct width (value) #:transparent)
(struct end (x y) #:transparent)
(struct start (x y) #:transparent)
(struct fp_line (start end layer width) #:transparent)

(define (module name expr . exprs)
  `(module ,name ,(list expr exprs)))


(struct layer (value)
 #:methods gen:custom-write
    [(define (write-proc layer port mode)
      (write-string (~a "(layer " (layer-value layer) ")") port))])
