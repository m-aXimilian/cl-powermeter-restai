(in-package :cl.powermeter.restapi)

(defun json-string-from-calculation (calc)
  "Gives a json string corresponding to the `uid' of a calculation object."
  (check-type calc power-calculation)
  (cl-json:encode-json-to-string calc))

;; call like http://10.168.50.28:8771/?power=a039408b-b369-40f2-ba22-c20bdf4b24fb
(defun setup-power-handler ()
  (hunchentoot:define-easy-handler (power-disptacher :uri "/") (power)
    (setf (hunchentoot:content-type*) "application/json")
    (format nil "~a" (json-string-from-calculation (power-calculation-with-uid power)))))

;; call like http://10.168.50.28:8771/queryfreq?hz=4
(defun setup-frequency-handler ()
  (hunchentoot:define-easy-handler (set-frequency :uri "/queryfreq") (hz)
    (setf (hunchentoot:content-type*) "text/html")
    (let ((freq (ignore-errors
                 (parse-float hz))))
      (labels ((check-bounds (num)
                 (cond
                   ((> num 10.0) nil)
                   ((< num 0.0005) nil)
                   (t t))))
        (if (and freq (check-bounds freq))
            (progn
              (update-frequency freq)
              ;; (format nil "Set ~a Hz" freq))
              (format nil "Ok 👍, now running on ~aHz" freq))
            (format nil "Sorry, you gave me: \"~a\", which is either not of type number or out of bounds [10.0Hz ... 0.0005Hz]~%No changes made 👎" hz))))))

(defun start-server ()
  (setup-power-handler)
  (setup-frequency-handler)
  (hunchentoot:start *http-acceptor*))

(defun stop-server ()
  (hunchentoot:stop *http-acceptor*))
