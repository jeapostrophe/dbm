#lang scheme
(require scheme/foreign)
(unsafe!)

(define dbm-lib
  (ffi-lib "libdbm"))

(define-syntax-rule (define-dbm obj typ)
  (define obj
    (get-ffi-obj (symbol->string 'obj) dbm-lib typ
                 (lambda ()
                   (error 'dbm-lib "Installed dbm does not provide: ~a" 'obj)))))

(define-cpointer-type _DBM)
(define _mode_t _uint)

#|
typedef struct {
             char *dptr;
             int dsize;
     } datum;
|#
(define-cstruct _datum 
  ([dptr _string]
   [dsize _int]))

(define (string->datum s)
  (make-datum s (add1 (string-length s))))
(define (datum->string d)
  (datum-dptr d))

;     int
;     dbm_error(DBM *db);
(define-dbm dbm_error (_fun _DBM -> _int))

;     int
;     dbm_clearerr(DBM *db);
(define-dbm dbm_clearerr (_fun _DBM -> _int))

;     int
;     dbm_delete(DBM *db, datum key);
(define-dbm dbm_delete (_fun _DBM _datum -> _int))

;     void
;     dbm_close(DBM *db);
(define-dbm dbm_close (_fun _DBM -> _int))

;     datum
;     dbm_nextkey(DBM *db);
(define-dbm dbm_nextkey (_fun _DBM -> _datum))

;     datum
;     dbm_firstkey(DBM *db);
(define-dbm dbm_firstkey (_fun _DBM -> _datum))

;     DBM *
;     dbm_open(const char *file, int open_flags, mode_t file_mode);
(define-dbm dbm_open 
  (_fun _path _uint _mode_t
        -> _DBM/null))

(define _store_mode_t
  (_enum '(DBM_INSERT DBM_REPLACE)))
  
;     int
;     dbm_store(DBM *db, datum key, datum content, int store_mode);
(define-dbm dbm_store
  (_fun _DBM _datum _datum _store_mode_t
        -> _int))

;     datum
;     dbm_fetch(DBM *db, datum key);
(define-dbm dbm_fetch
  (_fun _DBM _datum
        -> _datum))

(provide datum?
         string->datum
         datum->string
         dbm_error
         dbm_clearerr
         dbm_delete
         dbm_close
         dbm_nextkey
         dbm_firstkey
         dbm_open
         dbm_store
         dbm_fetch)