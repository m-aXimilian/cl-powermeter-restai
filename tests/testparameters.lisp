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
  (initialize-power-calculations :reset t)
  (&body)
  (setf *power-calculation-alist* nil))
