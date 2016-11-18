(pretty-print
  (kicad-expand
    (for/list ([i (range 5)])
      (for/list ([j (range 5)] [k (range 3)])
        (list
          (fp_text 1 (at 0 i))
          (fp_line (start 0 0) (end i j) (layer F.Cu) (width k)))))))
