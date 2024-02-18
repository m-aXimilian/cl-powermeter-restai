(in-package :cl.powermeter.restapi)

(defun initialize-power-calculations (&optional (reset nil))
  "Setup a list of `power-calculation' objects.

Depends on the obis-mapping in `*uid-obis-code-alist*' and fills
the `*power-calculation-alist*'.
"
  (when reset
    (setf *power-calculation-alist* nil))
  (dolist (pair *uid-obis-code-alist*)
    (push `(,(cdr pair) . ,(make-instance 'power-calculation :uuid (car pair))) *power-calculation-alist*)))
