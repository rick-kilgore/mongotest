
VMDao = require 'lib/vmdao'
dao = new VMDao '127.0.0.1',
                27017,
                () ->
                    dao.findDocs (error, docs) ->
                        for doc in docs
                            console.log('%j', doc)
                        dao.close()


