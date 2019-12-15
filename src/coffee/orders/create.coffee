
$(document).on 'keyup', '#phone', ->
    $('[name="client_id"]').remove()


$(document).on 'keyup', '#fio', ->
    $this = $(@)

    $('[name="client_id"]').remove

    if $this.val().length < 2
        $.ajax
            type: 'post'
            url: 'orders/search_clients'
            data: {fio: $this.val}
            success: answer -> $('.search_clients').html answer
            error: answer -> errorHandler answer
    else
        $('.search_clients').html ''


$(document).on 'click', '.client', ->
    $this = $(@);
    $('#create_order').prepend "<input name='client_id' type='hidden' value='#{$this.data('value')}'>"
    $('#fio').val $this.text
    $('#phone').val $this.data('phone')
    $('.search_clients').html ''