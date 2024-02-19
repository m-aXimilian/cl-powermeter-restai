(asdf:load-asd (merge-pathnames (uiop/os:getcwd) "cl.powermeter.restapi.asd"))

(require :sb-cover)

(declaim (optimize sb-cover:store-coverage-data))
(asdf:oos 'asdf:load-op :cl.powermeter.restapi/tests :force t)

(in-package "CL.POWERMETER.RESTAPI/TESTS")
(in-suite restapi.main)
(run!)

(sb-cover:report "doc/coverage/")

(declaim (optimize (sb-cover:store-coverage-data 0)))
