#lang racket

(provide eval-kicad_mod/draw eval-kicad_mod/evaluate)

(require racket/sandbox)
;(require
; racket/sandbox
; [make-evaluator
;  (->*
;   (Symbol)
;   (#:requires (List String))
;   (-> String (String -> Any)))])

;(: make-kicad-mod-evaluator
;   (-> String (-> String (-> String Any))))
(define (make-kicad-mod-evaluator name)
  (parameterize ([sandbox-memory-limit #f])
    (make-evaluator
      'racket
      #:requires `(,(~a "kicad_mod/" name ".rkt")))))

;(: eval-kicad_mod/draw (-> String (String -> Any)))
(define eval-kicad_mod/draw
  (make-kicad-mod-evaluator "draw"))

;(: eval-kicad_mod/evaluate (-> String (String -> Any)))
(define eval-kicad_mod/evaluate
  (make-kicad-mod-evaluator "evaluate"))
