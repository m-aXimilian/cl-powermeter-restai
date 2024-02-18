(in-package :cl.powermeter.restapi)

(defclass power-calculation ()
  ((uuid
    :initarg :uuid
    :initform (error "Cannot instantiate without uid.")
    :documentation "The uid of the calculation.")
   (timestamp
    :initarg :timestamp
    :documentation "The timestamp of the calculation. A unix timestamp.")
   (power
    :initarg :power
    :documentation "The calcuated power (in kW).")))
