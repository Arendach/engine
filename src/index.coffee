$(document).on 'click', '.close_notification', ->
    notification_id = $(@).data('id')
    $.ajax
        type: 'post'
        url: '/notification'
        data:
            id: notification_id,
            action: 'close_notification'
        success: window.location.reload
        error: (answer) -> errorHandler answer


$(document).on 'click', '.close_task', ->
    id = $(@).data 'id'
    type = $(@).data 'type'
    
    data =
        id: id
        type: type
        action: 'close_form'
    
    $.ajax
        type: 'post'
        url: '/task'
        data: data,
        success: (answer) -> myModalOpen answer
        error: (answer) -> errorHandler answer

$(document).on 'submit', '#close_task', (event) ->
    event.preventDefault()
    
    data = $(@).serializeJSON()
    data.action = 'close'
    
    $.ajax
        type: 'post'
        url: '/task'
        data: data,
        success: (answer) -> successHandler answer
        error: (answer) -> errorHandler answer
