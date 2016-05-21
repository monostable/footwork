#lang racket/gui
(module kicad_mod "kicad_mod.rkt")
(require 'kicad_mod)

(define my-module
  (kicad_module Neosid_Air-Coil_SML_1turn_HDM0131A (layer B.Cu) (tedit 56CA2F43)
    (fp_text "hi" (at 1 1)) (fp_text "lo" (at 20 20))))

(define frame (new frame%
                   [label "Example"]
                   [width 300]
                   [height 300]))
(new canvas% [parent frame]
             [paint-callback (lambda (canvas dc) (my-module dc))])
(send frame show #t)