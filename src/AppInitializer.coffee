
class AppInitializer

    # An initializer is an instance of a class that provides an init method with the following prototype
    # that takes its input from the passed-in appContext, does some setup work, and adds to the appContext
    # for future initializers and the service.  Here is the required init function prototype:
    #
    #   init: (appContext, callback) -> ...
    #
    constructor: (@initializersList) ->
        @appContext = { }
        console.log '@appContext = %j', @appContext

    start: (mainCallback) ->
        @_runInits 0, mainCallback

    _runInits: (iAction, mainCallback) ->
        if iAction >= @initializersList.length
            mainCallback(@appContext)
        else
            @initializersList[iAction].init @appContext, () => @_runInits iAction+1, mainCallback

module.exports = AppInitializer
