(import-macros {: args} :macros)
(local pretty (require :fennel.view))
(local html (require :html))

(local db (ConnectDb))

(H.setRoute (H.GET "/status403") H.serve403)

;; (H.setRoute (args "/*" &
;;                   :scheme "https"
;;                   :otherwise
;;                   #(H.serveRedirect (H.makeUrl {:scheme "https"}))))

(fn hello-html [r]
  (html [:html {:lang "en"}
         [:body {}
          [:h1 {} (string.format "Welcome %s!" r.name)]]]))

(H.setTemplate :hello hello-html)
;; (H.setTemplate :hello "<h3>Welcome {%& name %}!</h3>")

(H.setRoute "/hello/:name"
  (fn [r]
    (dbg)
    (H.serveContent
      :hello
      {:name r.params.name})))
