(local {: sym} (require :fennel))

(fn args [...]
  (let [args [...]
        t {}]
    (var j 0)
    (each [i x (ipairs args) :until (= x (sym "&"))]
      (set j i)
      (table.insert t x))
    (for [i (+ j 2) (length args) 2]
      (tset t (. args i) (. args (+ i 1))))
    t))

{: args}
