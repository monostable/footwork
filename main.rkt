#!/usr/bin/env racket
#lang racket/gui

(require "kicad_mod.rkt")

(define frame (new frame% [label "Footwork"]))
(define menu-bar (new menu-bar% [parent frame]))

;;; the file menu items
(define file-menu (new menu%
                       (label "&File")
                       (parent menu-bar)))


(new menu-item%
     (label "&Open")
     (parent file-menu)
     (callback
       (λ (item event)
          (let ([path (send editor get-file #f)])
            (cond
              [(path-string? path)
               (send editor load-file path 'text)
               (send editor set-filename path)]
              [else #t])))))

(new menu-item%
     (label "&Save")
     (parent file-menu)
     (callback
       (lambda (item event)
         [send editor save-file
               (send editor get-filename) 'text])))

(define edit-menu (new menu% [label "&Edit"] [parent menu-bar]))
(define module-menu (new menu% [label "&Module"] [parent menu-bar]))

(define (get-buffer) [open-input-string (send editor get-text)])
(define (set-buffer text)
  [send editor begin-edit-sequence]
  [send editor select-all]
  [send editor insert text]
  [send editor end-edit-sequence])

(define (buffer-to-paint-callback) [eval-kicad_mod/draw (read (get-buffer))])

(define menu-item-render
  (new menu-item%
       [label "&Re-render"]
       [parent module-menu]
       [callback
         (λ (b e) (send canvas refresh-now))]
       [shortcut #\r]))

(define menu-item-evaluate
  (new menu-item%
       [label "&Evaluate code"]
       [parent module-menu]
       [callback
         (λ (b e) (set-buffer "hohoho"))]
       [shortcut #\e]))

(append-editor-operation-menu-items edit-menu #t)


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
(define editor (new text%))
(send editor set-max-undo-history 'forever)

(send editor-canvas set-editor editor)
(send editor load-file "example.kicad_mod")
(send editor-canvas focus)
(send frame show #t)
