(in-package :cl.powermeter.restapi)

(defun initialize-power-calculations (&key (reset nil))
  "Setup a list of `power-calculation' objects.

Depends on the obis-mapping in `*uid-obis-code-alist*' and fills
the `*power-calculation-alist*'.
The existing items in `*power-calculation-alist*' will be purged
when `reset' evaluates to `t'.
"
  (when reset
    (setf *power-calculation-alist* nil))
  (dolist (pair *uid-obis-code-alist*)
    (push `(,(cdr pair) . ,(make-instance 'power-calculation :uuid (car pair))) *power-calculation-alist*)))

(defun power-calculation-with-uid (uid)
  "Gives a `power-calculation' object corresponding to the given `uid'."
  (let ((found (find uid *power-calculation-alist*
                     :test #'(lambda (search-item list-item) (equal (slot-value (cdr list-item) 'uuid) search-item)))))
    (when found
      (cdr found))))
