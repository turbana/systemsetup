(define-module (tornado)
  #:use-module (gnu)
  #:use-module (gnu services xorg)
  #:use-module (base-system))

(use-service-modules ssh)


(let ((parent (base-operating-system
               "5CD3-F7B5" ;; boot uuid
               "39406bbf-01f9-4de2-88a9-d14a90fa2e75" ;; root uuid
               "6e9af107-9d7b-4bc2-843c-9afe9d1a4660"))) ;; swap uuid
  (operating-system
    (inherit parent)
    (host-name "tornado")

    (services
     (cons*
      ;; run an ssh server while bootstraping
      (service openssh-service-type)
      (modify-services (operating-system-user-services parent)
        ;; auto log into my wm
        (slim-service-type config =>
                           (slim-configuration
                            (inherit config)
                            (auto-login? #t)
                            (default-user "ian"))))))
    ))
