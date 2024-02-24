(in-package :cl.powermeter.restapi)

;; initalize calculation objects
(initialize-power-calculations)

;; setup handler for the obis-code map from function
;; (dolist (pair *uid-obis-code-alist*)
;;   (powermeter/easy-handler-power-from-id (car pair)))

;; (defvar tmp-id nil)
;; (dolist (pair *uid-obis-code-alist*)
;;   (setf tmp-id (car pair))
;;   (auto-named-easy-handler tmp-id))

;; bug in `auto-named-easy-handler' -> does not compile
;; comment out, recompile and then compile `auto-named-easy-handler'
;; with C-c C-c/ C-x C-e before running (and uncommenting & recompiling) set-handlers
;; (defvar set-handlers
;;       (lambda ()
;;         (auto-named-easy-handler "ba99af97-bf45-4739-840d-ab54b4c8b614")
;;         (auto-named-easy-handler "bbcb0184-fe16-4f08-be00-4e63ac1f6369")
;;         (auto-named-easy-handler "375e80fd-133b-4ca4-a18a-6427c8c5ddca")
;;         (auto-named-easy-handler "a039408b-b369-40f2-ba22-c20bdf4b24fb")))
;; (funcall set-handlers)
;; (auto-named-easy-handler "ba99af97-bf45-4739-840d-ab54b4c8b614")

(dolist (id-obis *uid-obis-code-alist*)
    (spawn-hunchentoot-easy-handler (car id-obis)))

(defun create-handler (id)
  (spawn-hunchentoot-easy-handler id))

(spawn-hunchentoot-easy-handler "ba99af97-bf45-4739-840d-ab54b4c8b614")
;; (spawn-hunchentoot-easy-handler (car (first *uid-obis-code-alist*)))
;; ⛔ this creates the same hanlder name!!
(create-handler "375e80fd-133b-4ca4-a18a-6427c8c5ddca")
(create-handler "a039408b-b369-40f2-ba22-c20bdf4b24fb")
;; start the server
(hunchentoot:start *http-acceptor*)
;; (auto-named-easy-handler (car (first *uid-obis-code-alist*)))

(defun start-shizzle ()
  (loop
    (progn
      (let ((rnd (random 100)))
        (dolist (e *uid-obis-code-alist*)
          (setf (slot-value (power-calculation-with-uid (car e)) 'power) rnd))))
    (sleep 10)))

;; (start-shizzle)                         
