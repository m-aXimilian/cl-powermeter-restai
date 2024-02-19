(in-package :cl.powermeter.restapi)

;; initalize calculation objects
(initialize-power-calculations)

;; setup handler for the obis-code map
(dolist (pair *uid-obis-code-alist*)
  (powermeter/easy-handler-power-from-id (car pair)))

;; (hunchentoot:define-easy-handler (json-data :uri "/") ()
;;   (with-output-to-string (stream)
;;     (let ((*print-pretty* t))
;;       ;; (format stream "~a" *data*)
;;       (format stream "~a" (cl-json:encode-json-to-string (first *list-of-reads*)))
;;       )))

;; (hunchentoot:define-easy-handler (power-with-id :uri "/a039408b-b369-40f2-ba22-c20bdf4b24fb") ()
;;     (let ((*print-pretty* t))
;;       (with-output-to-string (stream)
;;            (format stream "~a" (json-string-from-calculation (power-calculation-with-uid "a039408b-b369-40f2-ba22-c20bdf4b24fb")))
;;            )))


;; start the server
(hunchentoot:start *http-acceptor*)
