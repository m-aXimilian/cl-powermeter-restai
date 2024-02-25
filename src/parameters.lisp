(in-package :cl.powermeter.restapi)

(defconstant +time-diff-factor+ 3600000.0
  "Factor to get from ms and W to h and kW.")

(defparameter *server-host-ip* "localhost"
  "The ip address that gets served.")

(defparameter *server-host-port-power-calculations* 8771
  "The port where power calculations will be broadcasted.")

(defparameter *http-acceptor* (make-instance 'hunchentoot:easy-acceptor :port *server-host-port-power-calculations*)
  "The acceptor 'endpoint'.")

(defparameter *uid-obis-code-alist*
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

(defparameter *power-calculation-alist* nil
  "Intended as an alist with cons-cell semantic '(obis-code . `power-calculation')'.")

(defparameter *meter-reading-ip* nil
  "The ip address where we can fetch meter reading data.")

(defparameter *meter-reading-port* nil
  "The port of the meter reading api.")

(defparameter *meter-transformer-ratio* 20
  "The transformer ratio used with the electricity meter.")

(defun obis->uid (obis &optional (uid-obis-map *uid-obis-code-alist*))
  "Gives the corresponding uid for a given `obis' code.

By default, `*uid-obis-code-alist*' will be used to fetch the uid when no
paramter for `uid-obis-map' is provided"
  (car (rassoc obis uid-obis-map :test 'equal)))

(defun uid->obis (uid &optional (uid-obis-map *uid-obis-code-alist*))
  "Gives the corresponding obis doce for a given `uid'.

By default, `*uid-obis-code-alist*' will be used to fetch the uid when no
paramter for `uid-obis-map' is provided"
  (cdr (assoc uid uid-obis-map :test 'equal)))
