(in-package :cl.powermeter.restapi)

(defun json-string-from-calculation (calc)
  "Gives a json string corresponding to the `uid' of a calculation object."
  (check-type calc power-calculation)
  (cl-json:encode-json-to-string calc))

;; call like ttp://10.168.50.28:8771/?power=a039408b-b369-40f2-ba22-c20bdf4b24fb
(defun setup-power-handler ()
  (hunchentoot:define-easy-handler (power-disptacher :uri "/") (power)
    (format nil "~a" (json-string-from-calculation (power-calculation-with-uid power)))))

(defun start-server ()
  (hunchentoot:start *http-acceptor*))
