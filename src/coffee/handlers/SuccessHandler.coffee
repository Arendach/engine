class SuccessHandler
    driver = 'toastr'
    after = 'close'

    constructor: (@answer) ->

    setDriver: (@driver) -> @

    setRedirectTo: (@redirectTo) -> @

    setAfter: (@after) ->
        @answer.title ?= 'Виконано'
        @answer.message ?= 'Дані успішно збережено'
        @

    setAfterCallable: (@callable) -> @

    apply: () ->
        if @.driver is 'toastr' then @applyToastr()
        if @.driver is 'sweetalert' then @applySweetalert()

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

        toastr.success @answer.message, @answer.title

    applySweetalert: () ->
        swal.fire
            title: @answer.title
            text: @answer.text
            icon: 'success'

module.exports = SuccessHandler
