#lang racket
(require "kicad_mod.rkt")
(define m (file->string "example.footwork_mod"))

;flatten lists only, flatten in racket/list also flattens structs
(define (flatten/list lst)
  (foldl
    (λ (x result)
      (if (list? x)
        (append result (flatten/list x))
        (append result (list x))))
    (list)
    lst))

; turns struct into list but also keeps the initial keyword unlike the one in
; racket/struct
(define (struct->list x)
  (let* ([de-struct
          (λ (sym)
            (let ([str (symbol->string sym)])
              (string->symbol
               (string-replace str "struct:" ""))))]
         [v (struct->vector x)]
         [s (de-struct (vector-ref v 0))])
    (begin
      (vector-set! v 0 s)
      (vector->list v))))

; recursively turn a arbitrarily deep list of structs into list of lists
(define (structs->lists x)
  (cond
    [(struct? x) (structs->lists (struct->list x))]
    [(list? x) (map structs->lists x)]
    [else x]))

(pretty-write
  (structs->lists
    (flatten/list
      (eval-kicad_mod/ast m))))
