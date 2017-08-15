{:user {:plugins [[lein-pprint "1.1.2"]
                  [jonase/eastwood "0.2.4"]
                  [lein-kibit "0.1.5"]
                  [lein-collisions "0.1.4"]]
;        :test-paths ["test", "itest"]
        :dependencies [[slamhound "1.5.5"]
                       [im.chit/vinyasa "0.3.4"]
                       [org.clojars.gjahad/debug-repl "0.3.3"]]
        :injections [(require '[vinyasa.inject :as inject])
                     (require 'alex-and-georges.debug-repl)
                     (inject/in
                       clojure.core >
                       [clojure.pprint pprint]
                       [alex-and-georges.debug-repl debug-repl])]}}

(defn spy [x] (println x) x)
