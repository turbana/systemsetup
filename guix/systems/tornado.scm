(define-module (tornado)
  #:export (tornado-system)
  #:use-module (base-system)
  #:use-module (gnu))

(use-service-modules ssh)

(operating-system
  (inherit base-operating-system)
  (host-name "tornado")

  (swap-devices
   (list (uuid "6e9af107-9d7b-4bc2-843c-9afe9d1a4660")))

  (file-systems
   (cons* (file-system
            (mount-point "/boot/efi")
            (device (uuid "5CD3-F7B5" 'fat32))
            (type "vfat"))
          (file-system
            (mount-point "/")
            (device
             (uuid "39406bbf-01f9-4de2-88a9-d14a90fa2e75"
                   'ext4))
            (type "ext4"))
          %base-file-systems))

  (packages
   (append
    (list (specification->package "screen")
          )
    (operating-system-packages base-operating-system)))

  (services
   (append
    (list (service openssh-service-type))
    (operating-system-user-services base-operating-system)))
  )
