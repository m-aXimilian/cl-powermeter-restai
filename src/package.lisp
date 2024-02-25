(defpackage cl.powermeter.restapi
  (:use :cl :hunchentoot :cl-json)
  (:export
   :obis->uid
   :uid->obis
   :initialize-power-calculations
   :*server-host-ip*
   :*server-host-port-power-calculations*
   :*http-acceptor*
   :*uid-obis-code-alist*
   :*power-calculation-alist*
   :*server-host-ip*
   :power-calculation-with-uid
   :power-calculation
   :power ;; the accessor function
   :meter-reading
   :restapi-request-service
   :meter-request-mock
   :meter-request
   :power-calculator
   :calculate-power
   :query-api
   ))
