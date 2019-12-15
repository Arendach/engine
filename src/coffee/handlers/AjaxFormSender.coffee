require('jquery-serializejson')

class AjaxFormSender
    constructor: () ->
        @.handlers()

    handlers: ->
        $ document
            .on 'submit', '[data-type=ajax]', @.handle

    handle: (event) ->
        event.preventDefault()

        data = $(event.target).serializeJSON()

        console.log(data)



export default AjaxFormSender