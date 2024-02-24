(in-package :cl.powermeter.restapi)

(defun json-string-from-calculation (calc)
  "Gives a json string corresponding to the `uid' of a calculation object."
  (check-type calc power-calculation)
  (cl-json:encode-json-to-string calc))
