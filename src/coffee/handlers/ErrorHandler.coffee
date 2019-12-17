class ErrorHandler
    driver: 'toastr'
    after: 'close'
    form: 'form'

    constructor: (@answer) ->
        if @answer.responseJSON?
            @title = @answer.responseJSON.title
            @message = @answer.responseJSON.message
            @errors = @answer.responseJSON.errors

        @errors ?= {}

    setMessages: ->
        if @answer.status is 0
            @error0Handler()
        else if @answer.status is 400
            @error400Handler()
        else if @answer.status is 401
            @error401Handler()
        else if @answer.status is 403
            @error403Handler()
        else if @answer.status is 404
            @error404Handler()
        else if @answer.status is 500
            @error500Handler()
        else if @answer.status is 504
            @error504Handler()
        else
            @title ?= 'Помилка'
            @message ?= 'Дані не вірно заповнені'

    error0Handler: () ->
        @title ?= 'Помилка'
        @message ?= 'Помилка зєднання з інтернетом :('

    error400Handler: () ->
        @title ?= 'Помилка'
        @message ?= 'Дані невірно заповнені'

        @validateErrorAppends()
        @eventListeners()

    error401Handler: () ->
        @title ?= 'Помилка'
        @message ?= 'Для продовження необхідно авторизуватись'

        window.open '/login?after=close'

    error403Handler: () ->
        @title ?= 'Помилка'
        @message ?= 'У вас немає доступу до даної дії'

    error404Handler: () ->
        @title ?= 'Помилка'
        @message ?= 'Не знайдено елемент або невірна адреса'

    error500Handler: () ->
        @title ?= 'Помилка'
        @message ?= 'Помилка сервера: 500. Дзвони до Тараса :('

    error504Handler: () ->
        @title ?= 'Помилка'
        @message ?= 'Час очікування минув. Сервер підвис кароче :)'

    validateErrorAppends: () ->
        for name, error of @errors
            if Array.isArray error then error = error.join '<br>'

            $ @form
                .find "[name='#{name}']"
                .parents '.form-group'
                .addClass 'has-error'

            $ "##{name}-error-block"
                .remove()

            $ "<span id='#{name}-error-block' class='help-block'>#{error}</span>"
                .insertAfter $(@form).find "[name='#{name}']"

    eventListeners: ->
        $ @form
            .find '[name]'
            .on 'keyup change', (event) ->
                return if event.key is 'Enter'

                name = $(@).attr 'name'
                $ "##{name}-error-block"
                    .remove()
                $ @
                    .parents '.form-group'
                    .removeClass 'has-error'

    setMessage: (@message) -> @

    setTitle: (@title) -> @

    setDriver: (@driver) -> @

    setAfter: (@after) -> @

    setAfterCallable: (@callable) -> @

    setFormElement: (@form) -> @

    apply: () ->
        @setMessages()
        
        if @driver is 'toastr' then @applyToastr()
        if @driver is 'sweetalert' then @applySweetalert()

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

        toastr.error @message, @title

    applySweetalert: () ->
        swal.fire
            title: @title
            text: @message
            icon: 'success'

module.exports = ErrorHandler
