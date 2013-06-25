mongo = require('mongodb')


class VMDao
    constructor: (@host, @port) ->
        @server = new mongo.Server('127.0.0.1', 27017, {auto_reconnect: true})
        @db = new mongo.Db('test', @server, { journal: true })
        @opened = false
        openHandler = (err, db) =>
                    if err?
                        console.log(err)
                        client.close()
                        throw err
                    @opened = true
                    console.log('opened = %s, this = %s, retrieving collection names...', @opened, @)
                    for field of this
                        console.log '%s = %s', field, this[field]
                    db.collectionNames((err, collections) ->
                        console.log("done.")
                        console.log(collections))
        @db.open openHandler

    getCollection: (callback) ->
        cb = () => @_getCollection callback
        @_waitForOpened cb

    findDocs: (callback) ->
        @_waitForOpened () => @_findDocs callback

    close: () -> @db.close()


    _waitForOpened: (callback) ->
        if @opened
            callback()
        else
            console.log('waiting for DB connection to open: opened = %s, this = %s', @opened, @, callback)
            cb = () => @_waitForOpened callback
            setTimeout(cb, 100)

    _getCollection: (callback) ->
        console.log("retrieving collection...")
        @db.collection('testData', (error, collection) ->
            if error?
                callback(error)
            else
                console.log('found collection.')
                callback(null, collection))

    _findDocs: (callback) ->
        @_getCollection (error, collection) ->
            if error
                callback(error)
            else
                console.log("calling find()...")
                collection.find().toArray((error, results) ->
                    console.log("find() returned.")
                    if error then callback(error)
                    else callback(null, results))

module.exports = VMDao
