
AppInitializer = require 'lib/AppInitializer'
Config = require 'lib/config'
VMDao = require 'lib/vmdao'

initializers = [
    new Config,
    new VMDao
]

query = (appContext, callback) ->
            appContext.vmdao.findDocs (error, docs) ->
                for doc in docs
                    console.log('%j', doc)
                callback()

insert = (appContext, num, callback) ->
    _insertBatch appContext, num, 0, 100, callback

_insertBatch = (appContext, num, iStart, batchSize, callback) ->
            if iStart >= num
                callback()
            else
                batch = []
                for i in [iStart..iStart+batchSize-1]
                    doc =
                        fileurl: "{cdn}/video/movies/2013/movie-#{i}.mov",
                        type: 'Movie',
                        title: "Movie #{i}",
                        writers: ['paul', 'jacob'],
                        director: 'lance',
                        producers: ['todd','kevin'],
                        cast: ['tom', 'chris'],
                        year: 2013,
                        genre: 'Action',
                        encoding: 'h264',
                        captions: yes,
                        duration: 145,  # minutes
                        resolution: [1024, 768],
                        description: "Epic adventure of a delusional toad who thinks he's a prince.  You'll laugh, you'll cry, you'll potentially lose your grip on reality!  Plus, he's really cute.  Look, watch this thing and I'll buy you lunch, damnit!"
                    batch.push doc
                appContext.vmdao.insertDocs batch, () ->
                    _insertBatch appContext, num, iStart+batchSize, batchSize, callback


quit = (appContext) ->
    console.log 'goodbye!'
    appContext.vmdao.close()
    process.exit 0


setupReadline = (appContext) ->
    readline = require('readline')
    rl = readline.createInterface process.stdin, process.stdout
    rl.setPrompt('> ')
    rl.prompt()

    rl.on 'close', () ->
        quit appContext

    rl.on 'line', (cmd) ->
        if cmd.search(/q/i) == 0
            quit appContext
        else if cmd.search(/find/i) == 0
            query appContext, () -> rl.prompt()
        else if cmd.search(/insert/i) == 0
            [cmd, num] = cmd.split ' '
            insert appContext, num, () -> rl.prompt()
        else
            rl.prompt()


app = new AppInitializer initializers
app.start setupReadline
