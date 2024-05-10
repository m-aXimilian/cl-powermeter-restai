(defpackage cl.powermeter.restapi
  (:use :cl :hunchentoot :cl-json)
  (:import-from :parse-float
                :parse-float)
  (:export
   :obis->uid
   :uid->obis
   :initialize-power-calculations
   :+time-diff-factor+
   :*server-host-ip*
   :*server-host-port-power-calculations*
   :*http-acceptor*
   :*uid-obis-code-alist*
   :*power-calculation-alist*
   :*meter-transformer-ratio*
   :*server-host-ip*
   :power-calculation-with-uid
   :power-calculation
   :power ;; the accessor function
   :timestamp ;; the accessor function
   :energy ;; the accessor function
   :query-frequency
   :parser
   :meter-reading
   :restapi-request-service
   :meter-request-mock
   :meter-request
   :power-calculator
   :calculate-power
   :query-api
   :main
   ))
