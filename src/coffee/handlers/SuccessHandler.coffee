class SuccessHandler
    constructor: (@answer, @res) ->
        @driver = 'toastr'
        @after = 'close'

        @message = @answer.message
        @title = @answer.title

    setMessages: ->
        if @res.status is 200
            @status200Handler()
        else if @res.status is 301
            @status301Handler()
        else
            @title ?= 'Виконано'
            @message ?= 'Дані успішно збережені'

    status200Handler: ->
        @title ?= 'Виконано'
        @message ?= 'Дані успішно збережені'

    status301Handler: ->
        @title ?= 'Виконано'
        @message ?= 'Дані успішно збережені'

    setDriver: (@driver) -> @

    setAfter: (@after) -> @

    setRedirectTo: (@redirectTo) -> @

    setAfterCallable: (@callable) -> @

    apply: () ->
        @setMessages()

        if @driver is 'toastr' then @applyToastr()
        else if @driver is 'sweetalert' then @applySweetalert()

    applyToastr: () ->
        toastr.options.escapeHtml = true
        toastr.options.closeButton = true
        toastr.options.closeMethod = 'fadeOut'
        toastr.options.closeDuration = 300
        toastr.options.closeEasing = 'swing'
        toastr.options.onHidden = @callable
        toastr.options.showMethod = 'slideDown';
        toastr.options.hideMethod = 'slideUp';
        toastr.options.closeMethod = 'slideUp';

        toastr.success @message, @title

    applySweetalert: () ->
        swal.fire
            title: @answer.title
            text: @answer.text
            icon: 'success'

module.exports = SuccessHandler
