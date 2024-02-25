(in-package :cl.powermeter.restapi/tests)

(defparameter *uid-obis-code-alist/tests*
  '(("a039408b-b369-40f2-ba22-c20bdf4b24fb"
     . "1.8.1")
    ("bbcb0184-fe16-4f08-be00-4e63ac1f6369"
     . "1.8.2")
    ("375e80fd-133b-4ca4-a18a-6427c8c5ddca"
     . "2.8.1")
    ("ba99af97-bf45-4739-840d-ab54b4c8b614"
     . "2.8.2"))
  "A map of obis codes and respective ids. This should match the ids
from an api that can be called to fetch (json) data for the respective codes.")

(def-fixture setup-power-calculation-alist ()
  (let ((restore *power-calculation-alist*))
    (initialize-power-calculations :reset t)
    (&body)
    (setf *power-calculation-alist* restore)))

(def-fixture double-initialize-calculation-alist ()
  (let ((restore *power-calculation-alist*))
    (setf *power-calculation-alist* nil)
    (initialize-power-calculations)
    (initialize-power-calculations)
    (&body)
    (setf *power-calculation-alist* restore)))

(def-fixture ensure-empty-calculation-alist ()
  (let ((restore *power-calculation-alist*))
    (setf *power-calculation-alist* nil)
    (&body)
    (setf *power-calculation-alist* restore)))

(defclass meter-request-mock-constant-power (restapi-request-service)
  ((energy-log
    :initarg :energy-log
    :initform 0
    :accessor energy-log
    :documentation "The saved energy reading to increment.")
   (last-read
    :initarg :last-read
    :initform nil
    :accessor last-read
    :documentation "Last meter reading.")
   (target-power
    :initarg :target-power
    :initform 1
    :accessor target-power
    :documentation "Gives the desired power and thus determines energy increments (in kW).")
   (sleep-time
    :initarg :sleep-time
    :initform 5
    :accessor sleep-time
    :documentation "Time between api-calls."))
  (:documentation "A mock implementation of `restapi-request-service' with energy increments of a fixed power."))

(defmethod query-api ((reader meter-request-mock-constant-power) uri)
  "Ensures an energy increment to target a static mean power in `uri'."
  (labels ((get-energy-inc (reader)
             (let ((now (get-universal-time)))
               (list now
                     (+ (* (target-power reader) (/ (- now (timestamp (last-read reader))) 3600000)) (energy (last-read reader)))))))
    (cond
      ((eq nil (last-read reader))
       (let ((initial (cl.powermeter.restapi::generate-meter-reading (cdr (assoc :data `((:VERSION . "0.8.1") (:GENERATOR . "vzlogger")
                                                                                                              (:DATA
                                                                                                               ((:UUID . ,uri)
                                                                                                                (:LAST . ,(get-universal-time))
                                                                                                                (:INTERVAL . -1)
                                                                                                                (:PROTOCOL . "d0")
                                                                                                                (:TUPLES (,(get-universal-time) ,(slot-value reader 'energy-log)))))))))))
         (setf (last-read reader) initial)
         initial))
      (t (let ((needed-inc (get-energy-inc reader)))
           (cl.powermeter.restapi::generate-meter-reading (cdr (assoc :data `((:VERSION . "0.8.1") (:GENERATOR . "vzlogger")
                                                                                                      (:DATA
                                                                                                       ((:UUID . ,uri)
                                                                                                        (:LAST . ,(car needed-inc))
                                                                                                        (:INTERVAL . -1)
                                                                                                        (:PROTOCOL . "d0")
                                                                                                        (:TUPLES (,(car needed-inc) ,(cadr needed-inc))))))))))))))
