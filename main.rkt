#!/usr/bin/env racket
#lang racket/gui
(require racket/sandbox)

(define eval-kicad_mod/draw
  (make-evaluator
    'racket/base
    #:allow-for-require '("kicad_mod/draw.rkt" racket)
    '(require "kicad_mod/draw.rkt")))

(define frame (new frame% [label "Footwork"]))
(define menu-bar (new menu-bar% [parent frame]))
(define menu-sub-edit (new menu% [label "Edit"] [parent menu-bar]))
(define menu-sub-view (new menu% [label "View"] [parent menu-bar]))

(define (buffer) [open-input-string (send text get-text)])

(define (buffer-to-paint-callback) [eval-kicad_mod/draw (read (buffer))])

(define menu-item-render
  (new menu-item%
       [label "Re-render"]
       [parent menu-sub-view]
       [callback
         (λ (b e) (send canvas refresh-now))]
       [shortcut #\r]))

(append-editor-operation-menu-items menu-sub-edit #t)

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
       [paint-callback (λ (canvas dc) ((buffer-to-paint-callback) dc))]
       [style '(no-focus)]))

(define editor-canvas (new our-editor-canvas% [parent frame]))
(define text (new text%))

(send editor-canvas set-editor text)
(send text load-file "example.kicad_mod")
(send editor-canvas focus)
(send frame show #t)
