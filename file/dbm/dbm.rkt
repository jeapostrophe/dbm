#lang racket/base
(require racket/match
         racket/dict
         racket/contract
         "dbm-ffi.rkt")

(define (dbm-open pth)
  (define O_RDWR 2)
  (define O_CREAT 512)
  (define O_SYMLINK 2097152)
  ;; XXX Do flags right
  (define the-db
    (or (dbm_open pth
                  (bitwise-ior O_RDWR O_SYMLINK)
                  432)
        (dbm_open pth
                  (bitwise-ior O_RDWR O_CREAT O_SYMLINK)
                  432)))
  (if the-db
    (dbm the-db)
    (error 'dbm-open "Could not open DBM: ~e" pth)))

(define (dbm-close! dbm)
  (unless (zero? (dbm_close (dbm-ptr dbm)))
    (error 'dbm-close! "dbm_close did not return zero")))

(define (dbm-next-key dbm)
  (datum->string (dbm_nextkey (dbm-ptr dbm))))
(define (dbm-first-key dbm)
  (datum->string (dbm_firstkey (dbm-ptr dbm))))
(define (dbm-clear-error! dbm)
  (unless (zero? (dbm_clearerr (dbm-ptr dbm)))
    (error 'dbm-clear-error! "dbm_clearerr did not return zero")))
(define (dbm-error dbm)
  (dbm_error (dbm-ptr dbm)))

(define (handle-dbm-error fun dbm)
  (define the-err (dbm-error dbm))
  (dbm-clear-error! dbm)
  (error fun "DBM Error: ~e" the-err))

(define (dbm-set! dbm key val
                  #:replace? [replace? #f])
  (define key-d (string->datum key))
  (define val-d (string->datum val))
  (case
      (dbm_store (dbm-ptr dbm) key-d val-d
                 (if replace? 'DBM_REPLACE 'DBM_INSERT))
    [(0) (void)]
    [(1) (error 'dbm-set! "Key already exists: ~e" key)]
    [(-1) (handle-dbm-error 'dbm-set! dbm)]))

(define (dbm-ref dbm key [fail (lambda () (error 'dbm-ref "Key does not exist: ~e" key))])
  (match (dbm_fetch (dbm-ptr dbm) (string->datum key))
    [#f
     (if (procedure? fail)
       (fail)
       fail)]
    [(? datum? d)
     (match (datum->string d)
       [#f
        (if (procedure? fail)
          (fail)
          fail)]
       [(? string? v)
        v])]))

(define (dbm-remove! dbm key)
  (case (dbm_delete (dbm-ptr dbm) (string->datum key))
    [(0) (void)]
    [(1) (error 'dbm-remove! "Key does not exist: ~e" key)]
    [(-1) (handle-dbm-error 'dbm-remove! dbm)]))

;; Struct
(define (dbm-count dbm)
  (let loop ([i 0] [first? #f])
    (if (if first? (dbm-next-key dbm) (dbm-first-key dbm))
      (loop (add1 i) #t)
      i)))

(define (dbm-iterate-first dbm)
  (define f-key (dbm-first-key dbm))
  (and f-key
       (cons f-key (dbm-ref dbm f-key))))
(define (dbm-iterate-next dbm last)
  (define f-key (dbm-next-key dbm))
  (and f-key
       (cons f-key (dbm-ref dbm f-key))))
(define (dbm-iterate-key dbm pos) (car pos))
(define (dbm-iterate-value dbm pos) (cdr pos))

(struct dbm (ptr)
        #:property prop:dict
        (vector dbm-ref
                (lambda (dbm key val)
                  (dbm-set! dbm key val #:replace? #t))
                #f
                dbm-remove!
                #f
                dbm-count
                dbm-iterate-first
                dbm-iterate-next
                dbm-iterate-key
                dbm-iterate-value))

(provide/contract
 [dbm? (any/c . -> . boolean?)]
 [dbm-open (path-string? . -> . dbm?)]
 [dbm-close! (dbm? . -> . void)]
 [dbm-remove! (dbm? string? . -> . void)]
 [dbm-set! ((dbm? string? string?) (#:replace? boolean?) . ->* . void)]
 [dbm-ref ((dbm? string?) ((or/c string? (-> string?))) . ->* . string?)])
