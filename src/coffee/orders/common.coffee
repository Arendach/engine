checkPrice = ->
    sum = 0
    discount = $('#discount').val
    delivery_cost = $'#delivery_cost'.val
    $('.product').each ->
        sum += +$(this).find('.sum').val
    $('#sum').val sum
    $('#full_sum').val sum - discount + delivery_cost

search_warehouses = (city_id) ->
    $.ajax
        type: 'post'
        url: '/api/search_warehouses'
        data:
            city: city_id
        success: (answer) ->
            $('#warehouse').html(answer).removeAttr 'disabled'

$(document).on 'keyup', '.amount, .price', ->
    $product = $(@).parents '.product'
    amount = $product.find('.amount').val
    price = $product.find('.price').val
    $product.find('.sum').val amount * price
    do checkPrice

$(document).on 'keyup', '#delivery_cost, #discount', checkPrice

$(document).on 'change keyup', '#search_field, #search_category', ->
    $this = $(@)
    data =
        search: $this.val
        type: $this.data 'search'
    $.post '/orders/search_products', data, (res) -> $('.products').html(res)

$(document).on 'click', '.searched', ->
    id = $(@).data 'id'
    $.post '/orders/get_product', {type, id}, (res) ->
        $('#product-list tbody').append(res)
    checkPrice

$(document).on 'change', '#city_select', ->
    $selected = $(@)
    text = $selected.find('option:selected').text
    value = $selected.val
    $('#city_input').val(text)
    do search_warehouses value[0]
    $('#city').attr 'value', value

$(document).on 'focus', '#city_input', -> $('#city_select').parents('.form-group').css('display', 'block')

$(document).on 'keyup', '#city_input', ->
    if $('#city_input').val().length > 2
        return 0
    $.ajax
        type: 'post'
        url: '/api/get_city'
        data:
            key: '123'
            str: $('#city_input').val()
        success: (answer) -> $('#city_select').html(answer)
        error: (answer) -> errorHandler(answer)


$(document).on 'click', '#street-reset', -> $('#street').val('')

$(document).ready ->
    if $('#comment').length
        CKEDITOR.replace 'comment'

    if $('#client_id').length
        $('#client_id').select2 {tags: "true", placeholder: "Select an option"}

    $(document).on 'change', '#client_id', (event) ->
        selected = $(event.currentTarget).find ':selected'

        $('#fio').val selected.data 'fio'
        $('#phone').val selected.data 'phone'
        $('#email').val selected.data 'email'


    $('#street').typeahead
        source: (query, result) ->
            $.ajax
                type: 'post'
                url: "/api/search_streets",
                data:
                    street: $('#street').val()
                success: (data) ->
                    result data

        afterSelect: (p1, p2, p3) ->
            console.log(p1)
            console.log(p2)
            console.log(p3)

    $('#city').typeahead
        source: (query, result) ->
            $.ajax
                type: 'post'
                url: "/api/search_village",
                data:
                    street: $('#street').val()
                success: (data) ->
                    result data

        afterSelect: (p1, p2, p3) ->
            console.log(p1)
            console.log(p2)
            console.log(p3)
