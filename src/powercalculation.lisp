(in-package :cl.powermeter.restapi)

(defclass power-calculation ()
  ((uuid
    :initarg :uuid
    :initform (error "Cannot instantiate without uid.")
    :documentation "The uid of the calculation.")
   (timestamp
    :initarg :timestamp
    :documentation "The timestamp of the calculation. A unix timestamp.")
   (power
    :initarg :power
    :documentation "The calcuated power (in kW).")))

(defclass meter-reading ()
  ((uuid
    :initarg :uuid
    :initform (error "UUID must be provided.")
    :documentation "The identifier of the meter channel.")
   (timestamp
    :initarg :timestamp
    :initform (error "TIMESTAMP must be provided.")
    :documentation "The timestamp as provided by the reading (not calculated).")
   (energy
    :initarg :energy
    :initform (error "ENERGY must be provided")
    :documentation "The actual reading in kWh.")))

(defclass restapi-request-service ()
  ((server-ip
    :initarg :server-ip
    :initform (error "Need a server to query.")
    :documentation "The IP address of a (reachable) RESTAPI that
can be used to query meter readings.")
   (server-port
    :initarg :server-port
    :initform 8080
    :documentation "The port of the RESTAPI. Defaults to 8080.")
   (loop-running-p
    :initarg :loop-running-p
    :initform nil
    :documentation "Statusflag inidicating whether the a query-loop is running.
Setfable; when T, you can set it to NIL in order to stop the loop.")
   (query-frequency
    :initarg :query-frequency
    :initform 0.005
    :documentation "The frequency in Hz indicating a 'sleep' time for the loop.
Is in use only when `loop-running-p' is T.")))

(defclass meter-request-mock (restapi-request-service)
  ((energy-log
    :initarg :energy-log
    :initform 0
    :documentation "The saved energy reading to increment.")))

(defclass meter-request (restapi-request-service)
  ())

(defclass power-calculator ()
  ((meter-api
    :initarg :meter-api
    :initform (error "You have to provide an API to query the meter readings.")
    :type restapi-request-service
    :documentation "A handler for calculating power from energy readings.")
   (last-read
    :type number
    :documentation "The last reading.")
   (power
    :type number
    :documentation "The calculated power.")))

(defgeneric query-api (reader uri)
  (:documentation "Get a json encoded api response from the url specified in `uri'."))

(defgeneric start-query-loop (reader)
  (:documentation "Starts a request loop on the configured api."))

(defgeneric calculate-power (calculator)
  (:documentation "Calculate power from subsequent meter readings."))

(defmethod calculate-power (calculator power-calculator)
  (let ((last (slot-value calculator 'last-read)))
    ()))

(defmethod query-api ((reader restapi-request-service) uri)
  (error "query-api is not defined on the interface."))

(defmethod query-api ((reader meter-request-mock) uri)
  "Random data containing the `uri'."
  (incf (slot-value reader 'energy-log) (random 100.0))
  (generate-meter-reading (cdr (assoc :data `((:VERSION . "0.8.1") (:GENERATOR . "vzlogger")
                                              (:DATA
                                               ((:UUID . ,uri) (:LAST . ,(get-universal-time))
                                                               (:INTERVAL . -1) (:PROTOCOL . "d0") (:TUPLES (,(get-universal-time) ,(slot-value reader 'energy-log))))))))))

(defmethod query-api ((reader meter-request) uri)
  "does sth like (cl-json:decode-json-from-string (map 'string #'code-char (drakma:http-request 'http://192.168.2.71:8770/uri')))"
  (error "Implement me"))

(defun generate-meter-reading (reading)
  "READING has to provide :uuid and :tuples"
  (let* ((uid (cdr (assoc :uuid (car reading)))))
    (multiple-value-bind (ti energy) (tuple-unpack (assoc :tuples (car reading)))
      (make-instance 'meter-reading
		     :uuid uid
		     :timestamp ti
		     :energy energy))))

(defun tuple-unpack (c)
  (let ((l (car (cdr c))))
    (values (car l)
	    (car (cdr l)))))

;; this is from cl-prototypes
;; try to not depend on drakma here and use usocket insteas as it is alreay part of hunchentoot
;; use the slot-values server-ip and server-port
;; (defmethod query-api ((reader meter-request) uri)
;;   (cl-json:decode-json-from-string (map 'string #'code-char (drakma:http-request "http://192.168.2.71:8770"))))
