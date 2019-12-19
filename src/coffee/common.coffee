window.SuccessHandler = require './handlers/SuccessHandler.coffee'
window.ErrorHandler = require './handlers/ErrorHandler.coffee'

patterns =
  comma: /\,/
  space: /\s/
  letter: /[a-zA-Zа-яА-Я]/
  anySym: /[\!\@\#\$\%\^\&\*\(\)\=\_\`\~\'\\\|\/\+\:\;\>\<\?]/
  point: /\./g
  hyphen: /\-/
  number: /\D/

document.ElementsExists = false
document.inputCache = ''

String::replaceAll = (search, replace) -> @.split(search).join(replace)

$(document).ready ->
    $('[data-toggle="tooltip"]').tooltip()
    $('[data-toggle="popover"]').popover()

    url = document.location.toString()
    if url.match '#'
        $('.nav-pills a[href="#' + url.split('#')[1] + '"]').tab('show')

$('.nav-pills a').on 'shown.bs.tab', (event) ->
    window.location.hash = event.target.hash


#Валідація поля типу decimal
$(document).on 'focus', '[data-inspect]', -> document.inputCache = $(@).val()

$(document).on 'focusout', '[data-inspect]', -> document.inputCache = ''

$(document).on 'change', '.input-file-input', (event) ->
    input_file_input = $ event.currentTarget
    input_file_container = input_file_input.parents '.input-file-container'
    input_file_names = input_file_container.find '.input-file-names'

    input_file_names.html ''

    files = input_file_input.prop 'files'
    for file in files
        input_file_names.append file.name + '<br>'


$(document).on 'keyup', '[data-inspect="decimal"]', ->
    value = $(@).val()
    
    return if value is ''
  
    value = value.replaceAll(patterns.comma, '.')
    value = value.replaceAll(patterns.space, '')
    value = value.replaceAll(patterns.letter, '')
    value = value.replaceAll(patterns.anySym, '.')

    pointCounter = if value.match(patterns.point) is null then 0 else value.match(patterns.point).length

    if pointCounter is 1
        split = value.split('.', 2)
        if split[1].length > 2 then value = document.inputCache
    else if pointCounter > 1
        value = document.inputCache

    document.inputCache = value

    $(@).val(value)

    
$(document).on 'keyup', '[data-inspect="integer"]', ->
    value = $(@).val()
    return if value is ''
    minus = value.match patterns.hyphen
    value = value.replaceAll patterns.number, ''
    value = "-#{value}" if minus
    $(@).val value

$(document).on 'submit', '[data-type="ajax"]', (event) ->
    event.preventDefault()
    
    #data = $(event.currentTarget).serializeJSON()
    url = $(event.currentTarget).attr 'action'
    type = $(event.currentTarget).attr 'method'
    redirectTo = $(event.currentTarget).data 'redirect-to'
    success = $(event.currentTarget).data 'success'
    error = $(event.currentTarget).data 'error'
    after = $(event.currentTarget).data 'after'

    data = new FormData(this)

    console.log(data)

    url ?= window.location
    type ?= 'post'
    success ?= 'toastr'
    error ?= 'toastr'
    after ?= 'close'
    redirectTo ?= window.location

    #data = Elements.customFormSerializePush data, @

    $ event.currentTarget
        .find '[name]'
        .attr 'disabled', yes

    $ event.currentTarget
        .find 'button'
        .attr 'disabled', yes
        .prepend '<i class="fa fa-circle-o-notch fa-spin"></i> '

    send = ->
        $.ajax
            type: type
            url: url
            data: data
            processData: off
            contentType: off
            success: (answer, status, jqXHR) =>
                new SuccessHandler answer, jqXHR
                    .setDriver success
                    .setRedirectTo redirectTo
                    .setAfter after
                    .apply()

                $ event.currentTarget
                    .find '[name]'
                    .attr 'disabled', no

                $ event.currentTarget
                    .find 'button'
                    .attr 'disabled', no
                    .find 'i'
                    .remove()
            error: (answer) =>
                new ErrorHandler answer
                    .setFormElement event.currentTarget
                    .setDriver error
                    .apply()

                $ event.currentTarget
                    .find '[name]'
                    .attr 'disabled', no

                $ event.currentTarget
                    .find 'button'
                    .attr 'disabled', no
                    .find 'i'
                    .remove()

    if typeof $(@).data('pin_code') != "undefined" then pin_code -> send() else send()

$(document).on 'click', '[data-type="delete"]', (event) ->
    event.preventDefault()

    id = $(@).data 'id'
    url = $(@).data 'uri'
    action = $(@).data 'action'
    data = $(@).data 'post'

    data = if data isnt undefined then "#{data}&action=#{action}" else {id, action}

    delete_on_click ->
        $.ajax
            type: 'post', url: url, data: data
            success: (answer) -> successHandler(answer)
            error: (answer) -> errorHandler(answer)

$(document).on 'click', '[data-type="get_form"]', (event) ->
    event.preventDefault()

    url = $(@).data 'uri'
    action = $(@).data 'action'
    post = $(@).data 'post'
    data = if post is undefined then "action=#{action}" else "#{post}&action=#{action}"

    $(@).attr 'disabled', yes

    $.ajax
        type: 'post', url: url, data: data
        success: (answer) ->
            myModalOpen answer
            $(@).attr 'disabled', no
        error: (answer) ->
            errorHandler answer
            $(@).attr 'disabled', no


$(document).on 'click', '[data-type="ajax_request"]', (event) ->
    event.preventDefault()

    url = $(@).data 'uri'
    data = $(@).data 'post'
    action = $(@).data 'action'

    data = "#{data}&action=#{action}"

    $.ajax
        type: 'post', url: url, data: data
        success: (answer) -> successHandler answer
        error: (answer) -> errorHandler answer

$(document).on 'click', '.map-signs', (event) ->
    current = $(event.currentTarget)
    content_left = $ '.content-left'
    content_right = $ '.content-right'
    navbar = $ '.content-right > .navbar'

    if current.data('state') is 'open'
        content_left.css 'left', '-220px'
        content_right.css 'margin-left', '0'
        navbar.css 'left', '0'
        current.data 'state', 'close'
        $.cookie 'left-content-state', 'close', expires: 5
    else
        content_left.css 'left', '0'
        content_right.css 'margin-left', '220px'
        navbar.css 'left', '220px'
        current.data 'state', 'open'
        $.cookie 'left-content-state', 'open', expires: 5



$(document).on 'hide.bs.modal', '.modal', -> $(@).remove()


$('a[data-type="pin_code"]').on 'click', ->
    href = $(@).data('href')
    pin_code -> window.location.href = href

$ document
    .on 'click', '.change-theme', (event) ->
        event.preventDefault()

        name = $ event.currentTarget
            .data 'name'

        href = $ event.currentTarget
            .data 'href'

        theme = $ event.currentTarget
            .data 'theme'

        $ '#baze-theme'
            .attr 'href', href

        $ '#theme-name'
            .text name

        $.ajax
            type: 'post'
            url: '/index/change_theme'
            data:
                theme: theme




window.str_to_int = (str) -> str.replace(/\D+/g, "")

window.getParameters = ->
    Pattern = /[\?][\w\W]+/
    params = document.location.href.match(Pattern)
    params = '' if params?

window.log = (type, desc) ->
    $.ajax
        type: 'post',
        url: '/log'
        data: {type, desc}


window.elog = (desc) -> log('error_in_javascript_file', desc)


window.redirect = (url) ->
    window.location.href = url


window.url = (path) ->
    path = path.replace(/^\//, '')
    "#{my_url}/#{path}"
