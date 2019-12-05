$(document).on 'click', '#submit', (event) ->
    event.preventDefault()
    login = $('#login').val()
    password = $('#password').val()
    remember_me = $('#remember_me').is(':checked')

    $.ajax
        type: 'post'
        url: '/login'
        data: {login, password, remember_me}
        success: =>
            if window.location.pathname is '/login' then window.location.href = site
            else window.location.reload()
        error: (answer) => alert answer.message