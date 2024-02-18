(in-package :cl.powermeter.restapi/tests)

(def-suite restapi.main
  :description "Testing the parameters of `cl.powermeter.restapi/tests'.")

(def-suite* restapi.main/parameters
  :in restapi.main
  :description "Global tests for the line parser.")

(test finds-uid-from-obis-code
  (is (obis->uid "1.8.1" *uid-obis-code-alist/tests*)))

(test finds-obis-from-uid
  (is (uid->obis "a039408b-b369-40f2-ba22-c20bdf4b24fb" *uid-obis-code-alist/tests*)))

(test invalid-uid-gives-nil
  (is-false (uid->obis "a-garbage-uid-not-in-alist" *uid-obis-code-alist/tests*)))

(test invalid-obis-gives-nil
  (is-false (obis->uid "0xff.0x00.1" *uid-obis-code-alist/tests*)))

(test power-calculations-alist-default-uninitialized
  (is-false *power-calculation-alist*))

(def-test power-calculations-alist-not-empty-when-initialized ()
  (with-fixture setup-power-calculation-alist ()
        (is (> (length *power-calculation-alist*) 0))))
