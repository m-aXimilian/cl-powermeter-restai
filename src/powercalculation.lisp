(in-package :cl.powermeter.restapi)

(defclass power-calculation ()
  ((uuid
    :initarg :uuid
    :initform (error "Cannot instantiate without uid.")
    :accessor uuid
    :documentation "The uid of the calculation.")
   (timestamp
    :initarg :timestamp
    :accessor timestamp
    :documentation "The timestamp of the calculation. A unix timestamp.")
   (power
    :initarg :power
    :initform nil
    :accessor power
    :documentation "The calcuated power (in kW)."))
  (:documentation "Type to be used for passing power claculation results."))

(defclass meter-reading ()
  ((uuid
    :initarg :uuid
    :initform (error "UUID must be provided.")
    :accessor uuid
    :documentation "The identifier of the meter channel.")
   (timestamp
    :initarg :timestamp
    :initform (error "TIMESTAMP must be provided.")
    :accessor timestamp
    :documentation "The timestamp as provided by the reading (not calculated).")
   (energy
    :initarg :energy
    :initform (error "ENERGY must be provided")
    :accessor energy
    :documentation "The actual reading in kWh."))
  (:documentation "Object representing a single read from an electricity meter."))

(defclass restapi-request-service ()
  ((server-ip
    :initarg :server-ip
    :initform (error "Need a server to query.")
    :accessor server-ip
    :documentation "The IP address of a (reachable) RESTAPI that
can be used to query meter readings.")
   (server-port
    :initarg :server-port
    :initform 8080
    :accessor server-port
    :documentation "The port of the RESTAPI. Defaults to 8080.")
   (parser
    :initarg :parser
    :initform (if *default-reastapi-parser*
                  *default-reastapi-parser*
                  (lambda (req) (identity req)))
    :accessor parser
    :type function
    :documentation "The function used to parse a GET request."))
  (:documentation "A generic interface exposing a rest api that can be used for GET http requests."))

(defclass meter-request-mock (restapi-request-service)
  ((energy-log
    :initarg :energy-log
    :initform 0
    :accessor energy-log
    :documentation "The saved energy reading to increment."))
  (:documentation "A mock implementation of `restapi-request-service'."))

(defclass meter-request (restapi-request-service)
  ()
  (:documentation "A production implementation of `restapi-request-service'."))

(defclass power-calculator ()
  ((meter-api
    :initarg :meter-api
    :initform (error "You have to provide an API to query the meter readings.")
    :type restapi-request-service
    :documentation "A handler for calculating power from energy readings.")
   (last-reads
    :initform nil
    :accessor last-reads
    :documentation "An alist of last readings.")
   (power
    :accessor power
    :type number
    :documentation "The calculated power.")
   (loop-running-p
    :initarg :loop-running-p
    :initform nil
    :reader loop-running-p
    :documentation "Statusflag inidicating whether the a query-loop is running.
Setfable; when T, you can set it to NIL in order to stop the loop.")
   (query-frequency
    :initarg :query-frequency
    :initform 0.005
    :accessor query-frequency
    :documentation "The frequency in Hz indicating a 'sleep' time for the loop.
Is in use only when `loop-running-p' is T.")
   (parser
    :initarg :parser
    :initform (lambda (calc)
                (dolist (key *uid-obis-code-alist*)
                  (calculate-power calc (car key))
                  ;; (format t "~a: ~a~%" (car key) (power (power-calculation-with-uid (car key))))
                  ))
    :accessor parser
    :documentation "Function for parsing the api call results from `meter-api'."))
  (:documentation "A power calculation handler based on restapi calls."))

(defgeneric query-api (reader uri)
  (:documentation "Get a json encoded api response from the url specified in `uri'."))

(defgeneric calculate-power (calculator uid)
  (:documentation "Calculate power from subsequent meter readings."))

(defgeneric start-calculation-loop (calculator)
  (:documentation "Start the calculator loop."))

(defgeneric stop-calculation-loop (calculator)
  (:documentation "Stop the calculator loop."))

(defmethod start-calculation-loop ((calculator power-calculator))
  (setf (slot-value calculator 'loop-running-p) t)
  (let* ((calc-thread (bt:make-thread
                       (lambda ()
                         (loop
                           (progn
                             (if (loop-running-p calculator)
                                 (progn
                                   (funcall (parser calculator) calculator)
                                   (sleep (/ 1.0 (query-frequency calculator))))
                                 (return nil)))))
                       :name "calc-thread")))
    calc-thread))

(defmethod stop-calculation-loop ((calculator power-calculator))
  (setf (slot-value calculator 'loop-running-p) nil))

(defmethod calculate-power ((calculator power-calculator) uid)
  (let ((last (assoc uid (last-reads calculator) :test 'equal))
        (current (query-api (slot-value calculator 'meter-api) uid)))
    (cond
      ((eq last nil) (push `(,uid . ,current) (last-reads calculator)))
      (t (progn
           (let*  ((energy-diff (- (energy current) (energy (cdr last))))
                   (time-diff (- (timestamp current) (timestamp (cdr last))))
                   (tmp-power (if (= 0 time-diff)
                                  nil ;; we don't want to divide by 0
                                  (* *meter-transformer-ratio* +time-diff-factor+ (/ energy-diff
                                                  time-diff)))))
             (if tmp-power
                 (progn (setf (power calculator) tmp-power)
                        (setf (cdr (assoc uid (last-reads calculator) :test 'equal)) current)
                        (setf (power (power-calculation-with-uid uid)) tmp-power)
                        (setf (timestamp (power-calculation-with-uid uid)) (timestamp current)))
                 (progn (setf (cdr (assoc uid (last-reads calculator) :test 'equal)) current)))))))))

;; depending on what we get from the real api, this has to be
;; ⚠️ adapted eventually
;; ✅ simply recycled, i.e., also used as the parser for the production restapi-handler
(defmethod initialize-instance :after ((reader restapi-request-service) &key)
  (setf (parser reader)
        (lambda (reading)
          (labels ((tuple-unpack (c)
                     (let ((l (car (cdr c))))
                       (values (car l)
                               (car (cdr l)))))
                   (extract-data (r)
                     (cdr (assoc :data (car r)))))
            (let* ((data (extract-data reading))
                   (uid (cdr (assoc :uuid (car data)))))
              (multiple-value-bind (ti energy) (tuple-unpack (assoc :tuples (car data)))
                (make-instance 'meter-reading
                               :uuid uid
                               :timestamp ti
                               :energy energy)))))))

(defmethod query-api ((reader restapi-request-service) uri)
  (error "query-api is not defined on the interface."))

(defmethod query-api ((reader meter-request-mock) uri)
  "Random data containing the `uri'."
  (incf (slot-value reader 'energy-log) (random 100.0))
  (funcall (parser reader) `(((:VERSION . "0.8.1") (:GENERATOR . "vzlogger")
                             (:DATA
                              ((:UUID . ,uri)
                               (:LAST . ,(get-universal-time))
                               (:INTERVAL . -1)
                               (:PROTOCOL . "d0")
                               (:TUPLES (,(get-universal-time) ,(slot-value reader 'energy-log)))))))))

(defmethod query-api ((reader meter-request) uri)
  (let ((req (concatenate 'string "http://" (server-ip reader) ":" (format nil "~a" (server-port reader)) "/" uri)))
    ;; (format t "~a" req)
    (funcall (parser reader)
             (list (cl-json:decode-json-from-string (map 'string #'code-char (drakma:http-request req)))))))

;; this is from cl-prototypes
;; try to not depend on drakma here and use usocket insteas as it is alreay part of hunchentoot
;; use the slot-values server-ip and server-port
;; (defmethod query-api ((reader meter-request) uri)
;;   (cl-json:decode-json-from-string (map 'string #'code-char (drakma:http-request "http://192.168.2.71:8770"))))
