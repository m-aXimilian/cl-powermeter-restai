(in-package :cl.powermeter.restapi)

;; initalize calculation objects


(defun main ()
  "The main entry point."
  (initialize-power-calculations)
  (setup-power-handler)
  (start-server))


;; test section
(setf meter-mock (make-instance 'meter-request-mock :server-ip *server-host-ip*))
(setf calculato (make-instance 'power-calculator :meter-api meter-mock))
(slot-value (query-api meter-mock (car (first *uid-obis-code-alist*))) 'energy)

(calculate-power calculato (car (first *uid-obis-code-alist*)))
;; (power (power-calculation-with-uid (car (first *uid-obis-code-alist*))))
