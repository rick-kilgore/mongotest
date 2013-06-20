
VMDao = require 'lib/vmdaoWithInit'
dao = new VMDao '127.0.0.1', 27017

cb = (error, docs) ->
    for doc in docs
        console.log('%j', doc)
    dao.close()

console.log 'calling dao.findDocs with cb = ', cb
dao.findDocs cb

