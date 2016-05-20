#!/usr/bin/env racket
#lang racket/gui

(define eval-pcbnew
  (let ((ns (make-base-namespace)))
    (parameterize ((current-namespace ns))
        (namespace-require 'racket))
    (lambda (expr) (eval expr ns))))

(define frame (new frame% [label "Footwork"]))
(define menu-bar (new menu-bar% [parent frame]))
(define menu-sub-edit (new menu% [label "Edit"] [parent menu-bar]))
(define menu-sub-view (new menu% [label "View"] [parent menu-bar]))

(define (buffer) [open-input-string (send text get-text)])

(define (render) [eval-pcbnew (read (buffer))])

(define menu-item-render
  (new menu-item%
       [label "Re-render"]
       [parent menu-sub-view]
       [callback
         (lambda (b e) (println (render)))]
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
       [style (list 'no-focus)]))

(define editor-canvas (new our-editor-canvas% [parent frame]))
(define text (new text%))

(send editor-canvas set-editor text)
(send text load-file "example.kicad_mod")
(send editor-canvas focus)
(render)
(send frame show #t)
