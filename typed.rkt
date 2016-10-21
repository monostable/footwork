#lang typed/racket/gui

(require "kicad_mod.rkt")

(: frame (Instance Frame%))
(define frame (new frame% [label "Footwork"]))

(: menu-bar (Instance Menu-Bar%))
(define menu-bar (new menu-bar% [parent frame]))

(: file-menu (Instance Menu%))
(define file-menu
  (new menu%
       (label "&File")
       (parent menu-bar)))


(send frame show #t)
