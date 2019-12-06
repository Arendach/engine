$(document).on 'change', '[name=category]',  ->
    $this = $(@)

    $.ajax
        type: 'post'
        url: '/product'
        data:
            id: $this.val()
            action: 'get_service_code'
        success: (answer) ->
            response = JSON.parse answer
            $('[name=services_code]').val response.message
            $('#fake-service-code').html response.message
            $('.service_code_container').show()
    
        error:  (answer) -> errorHandler answer
