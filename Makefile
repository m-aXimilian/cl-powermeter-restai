LISP ?= sbcl --noinform

test:
	$(LISP) --non-interactive --eval '(asdf:load-asd (merge-pathnames (uiop/os:getcwd) "cl.powermeter.restapi.asd"))' \
	--eval '(uiop:chdir (merge-pathnames (uiop/os:getcwd) "tests"))' \
	--eval '(ql:quickload :cl.powermeter.restapi/tests)' \
	--eval '(in-package "CL.POWERMETER.RESTAPI/TESTS")' \
	--eval '(in-suite restapi.main)' \
	--eval '(run!)' \

coverage:
	$(LISP) --non-interactive --load ./scripts/coverage.lisp

clean:
	rm -rf build

.PHONY: clean
