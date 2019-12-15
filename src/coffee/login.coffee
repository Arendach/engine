toastr = require 'toastr'

window.$(document).on 'click', '#submit', (event) ->
    event.preventDefault()
    login = $('#login').val()
    password = $('#password').val()
    remember_me = $('#remember_me').is(':checked')
    after = $('#after').val()

    $ event.target
        .attr 'disabled', yes

    $.ajax
        type: 'post'
        url: '/login'
        data: {login, password, remember_me}
        success: =>
            $ event.target
                .attr 'disabled', no

            if after is 'close'
                window.close()
            else
                if window.location.pathname is '/login' then window.location.href = '/'
                else window.location.reload()
        error: (answer) =>
            toastr.error answer.responseJSON.message, 'error'
            $ event.target
                .attr 'disabled', no