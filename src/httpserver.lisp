(in-package :cl.powermeter.restapi)

;; (defmacro powermeter/easy-handler-power-from-id (id &body)
;;   `(hunchentoot:define-easy-handler (power-with-id :uri ,id)
;;        (with-output-to-string (stream)
;;          (let ((*print-pretty* t))
;;            (format stream "~a" (json-string-from-calculation ))
;;            ))))
