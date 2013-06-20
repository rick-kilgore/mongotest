mongo = require('mongodb')


class VMDao
    constructor: () ->

    init: (appCtx, callback) ->
        console.log 'VMDao.init: appCtx = %j', appCtx
        @server = new mongo.Server(appCtx.host, appCtx.port, {auto_reconnect: true})
        @db = new mongo.Db(appCtx.dbName, @server, { journal: true })
        @collectionName = appCtx.collection
        _this = this
        @db.open (err, db) ->
                    if err?
                        console.log(err)
                        client.close()
                        throw err
                    console.log('retrieving collection names...')
                    appCtx.db = db
                    appCtx.vmdao = _this
                    db.collectionNames (err, collections) ->
                        console.log(collections)
                        callback()

    getCollection: (callback) ->
        console.log("retrieving collection...")
        @db.collection(@collectionName, (error, collection) ->
            if error?
                callback(error)
            else
                console.log('found collection %s', collection.collectionName)
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

    insertDocs: (docs, callback) ->
        @getCollection (error, collection) =>
            if error
                callback(error)
            else
                @_doInsert docs, 0, collection, callback

    _doInsert: (docs, index, collection, callback) ->
        if index >= docs.length
            callback()
        else
            console.log "inserting #{index}..."
            batch = docs[index...index+100]
            collection.insert batch, {safe: true}, () =>
                @_doInsert docs, index+100, collection, callback

    close: () -> @db.close()

module.exports = VMDao
