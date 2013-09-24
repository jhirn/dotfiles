{:user {:plugins [[lein-pprint "1.1.1"]
                  [alembic "0.2.0"]
                  [jonase/eastwood "0.0.2"]
                  [lein-autoexpect "1.0"]
                  [lein-ritz "0.7.0"]]
        :dependencies [[ritz/ritz-nrepl-middleware "0.7.0"]
                       [org.clojure/tools.trace "0.7.6"]
                       [nrepl-inspect "0.3.0"]]
        :repl-options {:nrepl-middleware
                       [inspector.middleware/wrap-inspect
                        ritz.nrepl.middleware.javadoc/wrap-javadoc
                        ritz.nrepl.middleware.simple-complete/wrap-simple-complete]}}}
