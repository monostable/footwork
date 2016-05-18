#!/usr/bin/env racket
#lang racket/gui

(define frame (new frame% [label "Footwork"]))
(define menu-bar (new menu-bar% [parent frame]))
(define menu-option-edit (new menu% [label "Edit"] [parent menu-bar]))
(append-editor-operation-menu-items menu-option-edit #f)

(define canvas (new editor-canvas% [parent frame]))
(define text (new text%))

(send canvas set-editor text)
(send frame show #t)
(send text load-file "example.kicad_mod")