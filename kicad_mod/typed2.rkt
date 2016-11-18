#lang typed/racket




(define-type At (U (List 'at Number Number Number) (List 'at Number Number)))

(: at ((Number Number) (Number) . ->* . At))
(define (at x y [o 0]) (if (eq? 0 o) `(at ,x ,y) `(at ,x ,y ,o)))


(define-type FpText (List 'fp_text String At))

(: fp_text (String At -> FpText))
(define (fp_text str at) `(fp_text ,str ,at))

(provide fp_text at)