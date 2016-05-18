#!/usr/bin/env racket
#lang racket/gui

(define frame (new frame% [label "Footwork"]))

(define canvas (new editor-canvas% [parent frame]))
(define text (new text%))
(send canvas set-editor text)
(send frame show #t)
