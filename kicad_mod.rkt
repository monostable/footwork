#lang typed/racket/gui

(provide eval-kicad_mod/draw)

(require/typed
 racket/sandbox
 [make-evaluator
  (->*
   (Symbol)
   (#:requires (List String))
   (-> String (String -> Any)))])

(: make-kicad-mod-evaluator
   (-> String (-> String (-> String Any))))
(define (make-kicad-mod-evaluator name)
  (make-evaluator
    'racket/base
    #:requires `(,(~a "kicad_mod/" name ".rkt"))))

(: eval-kicad_mod/draw (-> String (String -> Any)))
(define eval-kicad_mod/draw
  (make-kicad-mod-evaluator "draw"))
