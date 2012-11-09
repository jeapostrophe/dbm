#lang scribble/doc
@(require (for-label file/dbm
                     racket)
          scribble/manual)

@title{dbm}
@author{@(author+email "Jay McCarthy" "jay@racket-lang.org")}

@defmodule[file/dbm]

This package provides an interface to @link["http://en.wikipedia.org/wiki/Dbm"]{UNIX dbm} databases for Racket.

@defproc[(dbm? [v any/c])
         boolean?]{
 Returns @scheme[#t] if @scheme[v] is a dbm structure, @scheme[#f] otherwise.
         
 A dbm structure is a dictionary.
}

@defproc[(dbm-open [pth path-string?])
         dbm?]{
 Opens the dbm file at @scheme[pth], returning a handle.
}

@defproc[(dbm-close! [dbm dbm?])
         void]{
 Closes the database handled by @scheme[dbm].
}

@defproc[(dbm-remove! [dbm dbm?] [key string?])
         void]{
 Removes @scheme[key] from @scheme[dbm].
}

@defproc[(dbm-set! [dbm dbm?] [key string?] [val string?] [#:replace? replace? boolean? #f])
         void]{
 Sets @scheme[key] to @scheme[val] in @scheme[dbm]. Results in an error if @scheme[key] is present in @scheme[dbm] and @scheme[replace?] is not true.
}

@defproc[(dbm-ref [dbm dbm?] [key string?] [fail (or/c string? (-> string?))])
         string?]{
 Returns @scheme[key]'s value in @scheme[dbm], calling or returning @scheme[fail] if @scheme[key] is not present, like @scheme[dict-ref].
}
