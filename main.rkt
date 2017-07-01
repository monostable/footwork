#!/usr/bin/env racket
#lang racket/gui

(require framework)
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
     [label "&Save"]
     [parent file-menu]
     [shortcut #\s]
     [callback
       (lambda (item event)
         [send editor save-file
               (send editor get-filename) 'text])])

(define edit-menu (new menu% [label "&Edit"] [parent menu-bar]))
(define module-menu (new menu% [label "&Module"] [parent menu-bar]))

(define (get-buffer) [open-input-string (send editor get-text)])
(define (set-buffer text)
  [send editor begin-edit-sequence]
  [send editor select-all]
  [send editor insert text]
  [send editor end-edit-sequence])

(define (get-draw-function) (eval-kicad_mod/draw (read (get-buffer))))
(define (next-draw-function) (get-draw-function))
(define (draw-function) (get-draw-function))

(define (get-paint-callback)
  (let ([success #t])
    (with-handlers
      ([exn:fail?
         (λ (e) (set! success #f) (displayln e))])
      (set! next-draw-function (get-draw-function)) (set! success #t))
    (cond [success (set! draw-function next-draw-function)])
    draw-function))


(define menu-item-render
  (new menu-item%
       [label "&Re-render"]
       [parent module-menu]
       [callback
         (λ (b e) (send canvas refresh-now))]
       [shortcut #\r]))


(define (flatten/list lst)
  (foldl
   (lambda (x result)
     (if (list? x)
         (append result (flatten/list x))
         (append result (list x))))
   (list)
   lst))

(define (struct->list x)
  (let* ([v (struct->vector x)]
         [s (de-struct (vector-ref v 0))])
    (begin
      (vector-set! v 0 s)
      (vector->list v))))


(define (to-list x)
  (cond
    [(struct? x) (to-list (struct->list x))]
    [(list? x) (map to-list x)]
    [else x]))

(define (de-struct symbol)
  (let ([str (symbol->string symbol)])
    (string->symbol
     (string-replace str "struct:" ""))))

(define menu-item-evaluate
  (let ([cb
         (λ (b e)
          (set-buffer
            (pretty-format #:mode 'write
              (to-list
                (flatten/list
                  (struct->list (eval-kicad_mod/ast (read (get-buffer)))))))))])
    (new menu-item%
         [label "&Evaluate code"]
         [parent module-menu]
         [callback cb]
         [shortcut #\e])))

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

(define our-text%
  (class racket:text%
    (define/augment (after-save-file success?)
      (send canvas refresh-now))
    (super-new)))

(define canvas
  (new our-canvas%
       [parent frame]
       [paint-callback
         (λ (canvas dc) ((get-paint-callback) dc))]
       [style '(no-focus)]))

(define editor-canvas (new our-editor-canvas% [parent frame]))
(define editor (new our-text%))
(send editor set-max-undo-history 'forever)

(send editor-canvas set-editor editor)
(send editor load-file "example.kicad_mod")
(send editor-canvas focus)
(send frame show #t)
