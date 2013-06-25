mongo = require('mongodb')


class VMDao
    constructor: (@host, @port, callback) ->
        @server = new mongo.Server('127.0.0.1', 27017, {auto_reconnect: true})
        @db = new mongo.Db('test', @server, { journal: true })
        @opened = false
        @db.open (err, db) ->
                    if err?
                        console.log(err)
                        client.close()
                        throw err
                    console.log('retrieving collection names...')
                    db.collectionNames((err, collections) ->
                        console.log("done.")
                        console.log(collections))
                    @opened = true
                    callback()


    getCollection: (callback) ->
        console.log("retrieving collection...")
        @db.collection('testData', (error, collection) ->
            if error?
                callback(error)
            else
                console.log('found collection.')
                callback(null, collection))

    findDocs: (callback) ->
        @getCollection (error, collection) ->
            if error
                callback(error)
            else
                console.log("calling find()...")
                collection.find().toArray((error, results) ->
                    console.log("find() returned.")
                    if error then callback(error)
                    else callback(null, results))

    close: () -> @db.close()

module.exports = VMDao
