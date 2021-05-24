(define dropbox
  (let ((directory (string-append (getenv "HOME")
                                  "/dropbox")))
    (make <service>
      #:provides '(dropbox)
      #:docstring "Dropbox Daemon"
      #:start (make-system-constructor
               "dbxfs " directory)
      #:stop (make-system-destructor
              "fusermount -u " directory)
      #:respawn? #t)))
(register-services dropbox)
(start dropbox)
