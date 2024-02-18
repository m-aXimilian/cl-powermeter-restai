(defpackage cl.powermeter.restapi
  (:use :cl :hunchentoot :cl-json)
  (:export
   :obis->uid
   :uid->obis
   :initialize-power-calculations
   :*server-host-ip*
   :*server-host-port-power-calculations*
   :*uid-obis-code-alist*
   :*power-calculation-alist*))
