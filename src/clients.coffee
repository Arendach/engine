save = (event) ->
    event.preventDefault()
    client = $('#client_id').val()
    orders = []
    $('.selected').each ->
        orders.push $(@).attr 'data-id'

    $.ajax
        type: 'post'
        url: 'clients'
        data:
            client: client
            orders: orders
            action: 'save_orders'
        success: (answer) -> successHandler answer
        error: (answer) -> errorHandler answer


$(document).on 'click', '#search', (event)  ->
    event.preventDefault()
    data = {}
    client = $('#client_id').val()
    data['client'] = client
    $('form .search').each -> data[ $(@).attr 'name' ] = $(@).val() if $(@).val() isnt ''

    data.action = 'search_orders';

    $.ajax
        type: 'post'
        url: url('clients')
        data: data
        success: (answer) ->
            $('table .order_row').remove()
            $('table .recommended').remove()
            if answer.length > 10
                $('table.search tbody').append answer
                $('#save').css 'display', 'block'
            else
                $('#save').css 'display', 'none'
                $('table.search tbody').append '
                    <tr class="order_row">
                        <td colspan="5">
                            <h4 class="centered">Не знайдено, або вже прикріплено!</h4>
                        </td>
                    </tr>'

                    
$(document).on 'click', '#save', save

$(document).on 'click', '.order_row', -> $(@).toggleClass 'selected'
