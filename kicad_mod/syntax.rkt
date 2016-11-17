#lang racket
(require "provide-symbols.rkt")
(provide-symbols F.Cu B.Cu)
(struct kicad (expr))

(define (kicad->list expr)
  (match expr
    [(kicad (list e ...)) (quasiquote ((unquote-splicing e)))]))

(define-syntax-rule
  (fp_line (start start-x start-y) (end end-x end-y) (layer l) (width w))
  (kicad `(fp_line (start ,start-x ,start-y) (end ,end-x ,end-y) (layer ,l) (width ,w))))

;(let ([pattern (fp_line (start start-x start-y) (end end-x end-y) (layer l) (width w))])
;  (define-syntax-rule
;    pattern
;    `(fp_line (start #,start-x #,start-y) (end #,end-x #,end-y) (layer #,l) (width #,w)))



(map kicad->list
  (flatten
    (for/list ([i (range 5)])
      (for/list ([j (range 5)] [k (range 3)])
        (fp_line (start 0 0) (end i j) (layer F.Cu) (width k))))))
