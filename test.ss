#lang scheme
(require "dbm.ss")

;; Example
(define the-dbm (dbm-open "test"))

(for ([(k v) (in-dict the-dbm)])
  (printf "~S = ~S~n" k v))

(printf "Total: ~S~n" (dict-count the-dbm))

(for ([i (in-range 0 10)])
  (dict-set! the-dbm (format "key~a" i) (number->string i)))

(printf "Total: ~S~n" (dict-count the-dbm))

(with-handlers ([exn:fail? (lambda (x) (exn-message x))])
  (dbm-set! the-dbm "key8" "foo"))
(dbm-set! the-dbm "key8" "foo" #:replace? #t)

(dict-remove! the-dbm "key9")

(for ([i (in-range 0 10)])
  (define key (format "key~a" i))
  (printf "~S = ~S~n" key (dict-ref the-dbm key "default")))

(for ([(k v) (in-dict the-dbm)])
  (printf "~S = ~S~n" k v))
(for ([k (in-dict-keys the-dbm)])
  (printf "~S~n" k))
(for ([v (in-dict-values the-dbm)])
  (printf "~S~n" v))
(for ([v (in-dict-pairs the-dbm)])
  (printf "~S~n" v))

(printf "Total: ~S~n" (dict-count the-dbm))

(dbm-close! the-dbm)