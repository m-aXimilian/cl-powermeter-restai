(in-package :cl.powermeter.restapi)



(defun json-string-from-calculation (uid)
  "Gives a json string corresponding to the `uid' of a calculation object."
  ())

(hunchentoot:define-easy-handler (json-data :uri "/") ()
  (with-output-to-string (stream)
    (let ((*print-pretty* t))
      ;; (format stream "~a" *data*)
      (format stream "~a" (cl-json:encode-json-to-string (first *list-of-reads*)))
      )))

(hunchentoot:start (make-instance 'hunchentoot:easy-acceptor :port *server-host-port-power-calculations*))
