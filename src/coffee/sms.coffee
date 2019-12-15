$(document).on 'click', '.edit', ->
    data =
        action: 'update'
        id: $(@).parents('tr').data('id')
    
    $(@).parents('tr').find('.field').each -> data[$(@).attr 'name'] = $(@).val
    
    $.ajax
        type: 'post'
        url: url('/sms')
        data: data
        success: answer -> successHandler answer
        error: answer -> errorHandler answer