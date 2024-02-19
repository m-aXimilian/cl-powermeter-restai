(in-package :cl.powermeter.restapi)

(defun json-string-from-calculation (calc)
  "Gives a json string corresponding to the `uid' of a calculation object."
  (check-type calc power-calculation)
  (cl-json:encode-json-to-string calc))

;; THIS IS A BUG currently:
;; The "power-with-id" name is imortant here and cannot be redefined.
;; The uri must match the name of the symbol (in this case "power-with-id")
;; Using (gensym) does not work here. -> somehow use a macro?
(defun powermeter/easy-handler-power-from-id (id)
  "Generate an `hunchentoot:define-easy-handler' that handles the uri `id'.

Tries to answer get requests by a json-encoded `power-calculation' corresponding to `id'."
  (hunchentoot:define-easy-handler (power-with-id :uri (concatenate 'string "/" id)) ()
    (let ((*print-pretty* t))
      (with-output-to-string (stream)
           (format stream "~a" (json-string-from-calculation (power-calculation-with-uid id)))
           ))))

