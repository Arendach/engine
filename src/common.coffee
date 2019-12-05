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
    
    data = $(@).serializeJSON()
    url = $(@).attr 'action'
    redirectTo = $(@).data 'redirect-to'
    success = $(@).data 'success'

    data = Elements.customFormSerializePush(data, @) if document.ElementsExists

    $(@).find('button').attr 'disabled', yes

    send = ->
        $.ajax
            type: 'post'
            url: url
            data: data
            success: answer =>
                success = switch
                    when 'redirect' then successHandler answer, -> location.href = redirectTo
                    when 'close' then successHandler answer, yes
                    else  successHandler answer

                $(@).find('button').attr 'disabled', no
            error: answer =>
                errorHandler answer
                $(@).find('button').attr 'disabled', no

    if $(@).data('pin_code')? then pin_code -> send else send

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


$(document).on 'click', '#map-signs', (event) ->
    event.preventDefault()
    left_bar = $('#left_bar')
    content = $('#content')

    if left_bar.hasClass('mini-bar')
        left_bar.toggleClass('navigation', true)
        left_bar.toggleClass('mini-bar', false)
        $.cookie('left_bar_template_class', 'navigation', expires: 5)
    else
        left_bar.toggleClass('navigation', false)
        left_bar.toggleClass('mini-bar', true)
        $.cookie('left_bar_template_class', 'mini-bar', expires: 5)

    if content.hasClass('content-mini')
        content.toggleClass('content-big', true)
        content.toggleClass('content-mini', false)
        $.cookie('content_template_class', 'content-big', expires: 5)
    else
        content.toggleClass('content-big', false);
        content.toggleClass('content-mini', true);
        $.cookie('content_template_class', 'content-mini', expires: 5)


$(document).on 'hide.bs.modal', '.modal', -> $(@).remove()


$('a[data-type="pin_code"]').on 'click', ->
    href = $(@).data('href')
    pin_code -> window.location.href = href

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