(define-module (base-system)
  #:use-module (gnu))
(use-service-modules desktop networking ssh xorg)

(define-public base-operating-system
  (operating-system
   (locale "en_US.utf8")
   (timezone "America/Los_Angeles")
   (keyboard-layout (keyboard-layout "us"))
   (host-name "changeme")

   (bootloader
    (bootloader-configuration
     (bootloader grub-efi-bootloader)
     (target "/boot/efi")
     (keyboard-layout keyboard-layout)))

   ;; should be overwritten in child OS
   (file-systems (cons*
                  (file-system
                   (mount-point "/")
                   (device "none")
                   (type "tmpfs")
                   (check? #f))
                  %base-file-systems))

   (users (cons* (user-account
                  (name "ian")
                  (comment "Ian Clark")
                  (group "users")
                  (home-directory "/home/ian")
                  (supplementary-groups
                   '("wheel" "netdev" "audio" "video")))
                 %base-user-accounts))

   (packages
    (append
     (list (specification->package "i3-wm")
           (specification->package "i3status")
           (specification->package "dmenu")
           (specification->package "st")
           (specification->package "nss-certs"))
     %base-packages))

   (services
    (append
     (list (set-xorg-configuration
            (xorg-configuration
             (keyboard-layout keyboard-layout))))
     %desktop-services))
   ))
