#!/usr/bin/env racket
#lang racket/gui

(define frame (new frame% [label "Footwork"]))
(define menu-bar (new menu-bar% [parent frame]))
(define menu-option-edit (new menu% [label "Edit"] [parent menu-bar]))
(append-editor-operation-menu-items menu-option-edit #f)

(define our-editor-canvas%
  (class editor-canvas%
    (define/override (on-char ke)
      (match (send ke get-key-code)
             [x
               (eprintf "got ~v\n" x)]))
    (super-new)))

(define canvas (new our-editor-canvas% [parent frame]))
(define text (new text%))

(send canvas set-editor text)
(send text load-file "example.kicad_mod")
(eprintf "~a" (send text get-text))
(send frame show #t)
