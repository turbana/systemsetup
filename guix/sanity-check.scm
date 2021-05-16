(define-module (sanity-check)
  #:declarative? #f
  #:use-module (gnu)
  #:use-module (ice-9 pretty-print)
  #:use-module ((base-system)
                #:select (base-operating-system)))

(define tornado (load "systems/tornado.scm"))

(define (pretty-print-list L)
  (pretty-print (length L))
  (map pretty-print L))

(define (services os)
  (map (lambda (s)
         (service-type-name (service-kind s)))
       (operating-system-services os)))


;; (let* (
;;        (base-list (services base-operating-system))
;;        (child-list (services tornado))
;;        (only-base (filter (lambda (e) (not (memq e child-list)))
;;                           base-list))
;;        (only-child (filter (lambda (e) (not (memq e base-list)))
;;                            child-list))
;;        (common (filter (lambda (e) (memq e child-list))
;;                        base-list))
;;        )
;;   (pretty-print "total child:")
;;   (pretty-print (length child-list))
;;   (pretty-print "total base:")
;;   (pretty-print (length base-list))
;;   (pretty-print "only child:")
;;   (pretty-print-list only-child)
;;   (pretty-print "only base:")
;;   (pretty-print-list only-base)
;;   (pretty-print "in common:")
;;   (pretty-print-list common)
;;   )

(pretty-print-list (services tornado))
