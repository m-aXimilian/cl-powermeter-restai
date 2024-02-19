(in-package :cl.powermeter.restapi)

(initialize-power-calculations)

(dolist (pair *uid-obis-code-alist*)
  (progn
    (format t "~a~a~%" "created handler for: " (car pair))
    (powermeter/easy-handler-power-from-id (car pair))))

(hunchentoot:define-easy-handler (json-data :uri "/") ()
  (with-output-to-string (stream)
    (let ((*print-pretty* t))
      ;; (format stream "~a" *data*)
      (format stream "~a" (cl-json:encode-json-to-string (first *list-of-reads*)))
      )))

;; (hunchentoot:define-easy-handler (power-with-id :uri "/a039408b-b369-40f2-ba22-c20bdf4b24fb") ()
;;     (let ((*print-pretty* t))
;;       (with-output-to-string (stream)
;;            (format stream "~a" (json-string-from-calculation (power-calculation-with-uid "a039408b-b369-40f2-ba22-c20bdf4b24fb")))
;;            )))

(hunchentoot:start (make-instance 'hunchentoot:easy-acceptor :port *server-host-port-power-calculations*))
