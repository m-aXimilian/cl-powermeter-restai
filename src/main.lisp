(in-package :cl.powermeter.restapi)

;; initalize calculation objects
(initialize-power-calculations)

;; set handler
(hunchentoot:define-easy-handler (power-disptacher :uri "/") (power)
  (format nil "~a" (json-string-from-calculation (power-calculation-with-uid power))))

;; start the server
;; call likeh ttp://10.168.50.28:8771/?power=a039408b-b369-40f2-ba22-c20bdf4b24fb
(hunchentoot:start *http-acceptor*)

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
