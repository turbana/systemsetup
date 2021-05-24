(define emacs
  (make <service>
    #:provides '(emacs)
    #:docstring "Emacs Daemon"
    #:start (make-forkexec-constructor
             '("emacs" "--fg-daemon"))
    #:stop (make-kill-destructor)
    #:respawn? #f))

(register-services emacs)
(start emacs)
