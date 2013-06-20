fs = require('fs')

class Config
    constructor: () ->

    init: (appCtx, callback) ->
        console.log 'Config.init: appCtx = %j', appCtx
        fs.readFile 'test.cfg', (err, data) ->
            ctx = JSON.parse(data)
            for field of ctx
                appCtx[field] = ctx[field]
            callback()

module.exports = Config
