(defsystem "cl.powermeter.restapi"
  :version "0.0.1"
  :author "Maximilian Kueffner"
  :mailto "kueffnermax@gmail.com"
  :license "LGPL"
  :depends-on ("hunchentoot"
	       "cl-json")
  :components ((:module "src"
                :components
                ((:file "package")
                 (:file "parameters")
                 (:file "powercalculation")
                 (:file "domaininit")
                 (:file "httpserver")
                 (:file "main"))))
  :description ""
  :in-order-to ((test-op (test-op "cl.powermeter.restapi/tests"))))

(defsystem "cl.powermeter.restapi/tests"
  :author "Maximilian Kueffner"
  :license "LGPL"
  :depends-on ("cl.powermeter.restapi"
               "fiveam")
  :components ((:module "tests"
                :components
                ((:file "package")
                 (:file "testparameters")
                 (:file "main"))))
  :description "Test system for cl.powermeter.restapi"
  :perform (test-op (op c)
		    (symbol-call :fiveam :run!
				 (find-symbol* :cl.powermeter.restapi :cl.powermeter.restapi/tests))))
