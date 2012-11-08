#lang racket/base
(require "dbm.rkt"
         racket/dict
         tests/eli-tester)

;; Example
(define the-dbm #f)

(define the-vals
  '("0" "1" "2" "3" "4" "5" "6" "7" "foo"))
(define the-keys
  '("key0" "key1" "key2" "key3" "key4" "key5" "key6" "key7" "key8"))

(test
 (set! the-dbm (dbm-open "test"))
 
 (for ([(k v) (in-dict the-dbm)])
   (cons k v))
 
 (dict-count the-dbm)
 
 (for ([i (in-range 0 10)])
   (dict-set! the-dbm (format "key~a" i) (number->string i)))
 
 (dict-count the-dbm) => 10
 
 (dbm-set! the-dbm "key8" "foo") =error> "Key already exists:"
 
 (dbm-set! the-dbm "key8" "foo" #:replace? #t)
 
 (dict-remove! the-dbm "key9")
 
 (for/list ([i (in-range 0 10)])
   (dict-ref the-dbm (format "key~a" i) "default"))
 => (append the-vals (list "default"))
 
 (sort (for/list ([(k v) (in-dict the-dbm)]) (cons k v)) string<=? #:key car)
 => (map cons the-keys the-vals)
 
 (sort (for/list ([k (in-dict-keys the-dbm)]) k) string<=?)
 => the-keys
 
 (sort (for/list ([v (in-dict-values the-dbm)]) v) string<=?)
 => the-vals
 
 (sort (for/list ([v (in-dict-pairs the-dbm)]) v) string<=? #:key car)
 => (map cons the-keys the-vals)
 
 (dict-count the-dbm) => 9
 
 (dbm-close! the-dbm))
