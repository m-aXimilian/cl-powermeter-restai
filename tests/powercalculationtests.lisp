(in-package :cl.powermeter.restapi/tests)

(def-suite* restapi.main/powerclaculations
  :in restapi.main
  :description "Power calculation tests.")

(test calling-api-once-yields-no-power
  (let* ((meter-reading-mock (make-instance 'meter-request-mock :server-ip *server-host-ip*))
         (calculator (make-instance 'power-calculator :meter-api meter-reading-mock)))
    (initialize-power-calculations :reset t)
    (calculate-power calculator (car (first *uid-obis-code-alist*)))
    (is-false (power (power-calculation-with-uid (car (first *uid-obis-code-alist*)))))))
