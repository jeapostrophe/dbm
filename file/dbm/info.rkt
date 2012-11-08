#lang setup/infotab
(define name "dbm")
(define release-notes
  (list
   '(p "GDBM compatibility from Synx")
   '(p "Rackety")))
(define repositories
  (list "4.x"))
(define blurb
  (list "An interface to UNIX dbm databases"))
(define scribblings '(("dbm.scrbl" ())))
(define primary-file "main.rkt")
(define compile-omit-files '("test.rkt"))
(define categories '(datastructures))