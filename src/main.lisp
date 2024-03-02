(in-package :cl.powermeter.restapi)


(defvar global-meter-restapi (make-instance 'meter-request-mock :server-ip *server-host-ip*)
  "The restapi where the electricity meter readings can be fetched.")

(defvar global-calculator (make-instance 'power-calculator :meter-api global-meter-restapi :query-frequency 0.5)
  "The global calculator caring about power calculations based on `*uid-obis-code-alist*'.")

(defun main ()
  "The main entry point."
  (initialize-power-calculations :reset t)
  (setup-power-handler)
  (start-server)
  (start-calculation-loop global-calculator))
