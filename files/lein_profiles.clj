{:user {:plugins [[lein-pprint "1.3.2"]
                  [jonase/eastwood "1.2.3"]
                  [lein-kibit "0.1.8"]
                  [lein-collisions "0.1.4"]
                  [lein-ancient "1.0.0-RC3"]]

        :dependencies [[im.chit/vinyasa "0.4.7"]
                       [hashp "0.2.1" :exclusions [zprint]]
                       [zprint "1.2.3"]]
        :injections [(require '[vinyasa.inject :as inject])
                     (require 'hashp.core)
                     (inject/in
                       clojure.core >
                       [clojure.pprint pprint])]}}

