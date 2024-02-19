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
   :power-calculation-with-uid))
