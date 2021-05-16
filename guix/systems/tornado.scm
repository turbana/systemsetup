(define-module (tornado)
  #:export (tornado-system)
  #:use-module (base-system)
  #:use-module (gnu))

(use-service-modules ssh)

(use-modules (ice-9 pretty-print))


(let ((parent (base-operating-system
               "5CD3-F7B5" ;; boot uuid
               "39406bbf-01f9-4de2-88a9-d14a90fa2e75" ;; root uuid
               "6e9af107-9d7b-4bc2-843c-9afe9d1a4660"))) ;; swap uuid
  (pretty-print parent)
  (operating-system
    (inherit parent)
    (host-name "tornado")

    (packages
     (append
      (list (specification->package "screen")
            )
      (operating-system-packages parent)))

    (services
     (append
      (list (service openssh-service-type))
      (operating-system-user-services parent)))
    ))
