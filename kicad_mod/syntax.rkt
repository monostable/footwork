#lang racket
(require "provide-symbols.rkt")
(provide-symbols F.Cu B.Cu)
(struct kicad (expr))

(define (kicad->list expr)
  (match expr
    [(kicad (list e ...)) (quasiquote ((unquote-splicing e)))]))

(define (kicad-expand e)
  (map kicad->list
    (flatten e)))

(define-syntax-rule
  (fp_line (start start-x start-y) (end end-x end-y) (layer l) (width w))
  (kicad `(fp_line (start ,start-x ,start-y) (end ,end-x ,end-y) (layer ,l) (width ,w))))

(define-syntax-rule
  (fp_text str (at x y))
  (kicad `(fp_text ,str (at ,x ,y))))

(pretty-print
  (kicad-expand
    (for/list ([i (range 5)])
      (for/list ([j (range 5)] [k (range 3)])
        (list
          (fp_text 1 (at 0 i))
          (fp_line (start 0 0) (end i j) (layer F.Cu) (width k)))))))
