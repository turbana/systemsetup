(define-module (base-system)
  #:use-module (gnu))
(use-service-modules desktop networking ssh xorg)

(define-public (base-operating-system boot-uuid root-uuid swap-uuid)
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

   (file-systems
    (cons* (file-system
             (mount-point "/boot/efi")
             (device (uuid boot-uuid 'fat32))
             (type "vfat"))
           (file-system
             (mount-point "/")
             (device
              (uuid root-uuid 'ext4))
             (type "ext4"))
           %base-file-systems))

   (swap-devices
    (list (uuid swap-uuid)))

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
     (map specification->package
          '("i3-wm"
            "i3status"
            "dmenu"
            "st"
            "nss-certs"))
     %base-packages))

   (services
    (cons* (set-xorg-configuration
            (xorg-configuration
             (keyboard-layout keyboard-layout)))
           %desktop-services)
    ;; (append
    ;;  (list )
    ;;  %desktop-services)
    )
   ))