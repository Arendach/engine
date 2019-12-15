class UrlGenerator
    constructor: (params = window.location) ->
        @url = URI params

    unsetEmpty: () ->
        for key, value of @url.search true
            if value is '' then @url.removeQuery key
        @

    append: (key, value) ->
        @url.setQuery key, value
        @

    appends: (object) ->
        if Object.keys(object).length != 0
            for key, value of object
                @url.setQuery key, value
        @

    toString: -> @url.toString()

    unset: (key) ->
        @url.removeSearch key
        @

    go: ->
        window.location.href = @toString()

    redirect: ->
        window.open @toString()

    setRequest: () ->
        @search = @request()
        @

    dd: ->
        console.log @toString()

module.exports = UrlGenerator