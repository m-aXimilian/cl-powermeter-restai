(in-package :cl.powermeter.restapi)

;; initalize calculation objects
(initialize-power-calculations)

(setup-power-handler)
(start-server)

;; for debugging
(defun start-shizzle ()
  (loop
    (progn
      (let ((rnd (random 100)))
        (dolist (e *uid-obis-code-alist*)
          (setf (slot-value (power-calculation-with-uid (car e)) 'power) rnd)
          (setf (slot-value (power-calculation-with-uid (car e)) 'timestamp) (get-universal-time)))))
    (sleep 10)))

;; (start-shizzle)


;; test section
(setf meter-mock (make-instance 'meter-request-mock :server-ip *server-host-ip*))
(setf calculato (make-instance 'power-calculator :meter-api meter-mock))
(slot-value (query-api meter-mock (car (first *uid-obis-code-alist*))) 'energy)

(calculate-power calculato (car (first *uid-obis-code-alist*)))
