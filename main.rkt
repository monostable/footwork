#!/usr/bin/env racket
#lang racket/gui

(define frame (new frame% [label "Footwork"]))
(define menu-bar (new menu-bar% [parent frame]))
(define menu-option-file (new menu% [label "File"] [parent menu-bar]))
(define menu-option-edit (new menu% [label "Edit"] [parent menu-bar]))
(append-editor-operation-menu-items menu-option-edit #t)

(define our-canvas%
  (class canvas%
    (define/override (on-char ke)
      (match (send ke get-key-code)
             [x
               (eprintf "got ~v\n" x)]))
    (super-new)))

(define our-editor-canvas%
  (class editor-canvas%
    (super-new)))

(define canvas
  (new our-canvas%
       [parent frame]
       [style (list 'no-focus)]))

(send canvas accept-tab-focus #f)
(define editor-canvas (new our-editor-canvas% [parent frame]))
(define text (new text%))

(send editor-canvas set-editor text)
(send text load-file "example.kicad_mod")
(send editor-canvas focus)
(eprintf "~a" (send text get-text))
(send frame show #t)
