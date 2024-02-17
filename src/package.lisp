(defpackage cl.powermeter.restapi
  (:use :cl :hunchentoot :cl-json)
  (:export
   :obis->uid
   :uid->obis))
