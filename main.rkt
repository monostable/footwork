#!/usr/bin/env racket
#lang racket/gui
(require racket/sandbox)

(define (make-kicad-mod-evaluator name)
  (let ([file-path (~a "kicad_mod/" name ".rkt")])
  (make-evaluator
    'racket/base
    #:allow-for-require `(,file-path)
    `(require ,file-path))))

(define eval-kicad_mod/draw
  (make-kicad-mod-evaluator "draw"))

(define eval-kicad_mod/evaluate
  (make-kicad-mod-evaluator "evaluate"))

(define frame (new frame% [label "Footwork"]))
(define menu-bar (new menu-bar% [parent frame]))
(define menu-sub-edit (new menu% [label "Edit"] [parent menu-bar]))
(define menu-sub-module (new menu% [label "Module"] [parent menu-bar]))

(define (get-buffer) [open-input-string (send text get-text)])
(define (set-buffer)
            (send text begin-edit-sequence)
            (send text select-all)
            (send text insert "hohohoh")
            (send text end-edit-sequence))

(define (buffer-to-paint-callback) [eval-kicad_mod/draw (read (get-buffer))])

(define menu-item-render
  (new menu-item%
       [label "Re-render"]
       [parent menu-sub-module]
       [callback
         (λ (b e) (send canvas refresh-now))]
       [shortcut #\r]))

(define menu-item-evaluate
  (new menu-item%
       [label "Evaluate code"]
       [parent menu-sub-module]
       [callback
         (λ (b e) (set-buffer))]
       [shortcut #\e]))

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
(send text set-max-undo-history 'forever)

(send editor-canvas set-editor text)
(send text load-file "example.kicad_mod")
(send editor-canvas focus)
(send frame show #t)
