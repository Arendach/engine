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

$(document).ready ->
    $("#street").autocomplete
        source: (request, response) ->
            $.ajax
                type: 'post'
                url: '/api/search_streets'
                #dataType: 'json'
                data:
                    city: 'Kiev',
                    street: $('#street').val()
                success: (data) -> response(data)
        minLength: 3
    ###
        select: (event, ui) ->
            console.log(ui)
        open: ->
            $(this).removeClass("ui-corner-all").addClass("ui-corner-top");
        close: ->
            $(this).removeClass("ui-corner-top").addClass("ui-corner-all");###

        ###$(document).on 'keyup', '#street', ->
            $this = $(@)
            $('#street_select_container').show();
            $.ajax({
                type: 'post',
                url: url('/api/search_streets'),
                data: {
                    city: 'Київ',
                    street: $this.val()
                },
                success: function (answer) {
                    $('#street_select').html(answer);
            },
            error: function (answer) {
                errorHandler(answer);###



        ###

        $body.on('change', '#street_select', function () {
            $('#street').val($('#street_select :selected').text());
        $('#street_select_container').hide();
        });

        $body.on('keyup', '#city', function () {
            $('#city_select_container').show();
        var $this = $(this);
        $.ajax({
            type: 'post',
            url: url('/api/search_village'),
            data: {
                name: $this.val()
            },
            success: function (answer) {
                $('#city_select').html(answer);
        },
        error: function (answer) {
            errorHandler(answer);
        }
        })
        });

        $body.on('change', '#city_select', function () {
            $('#city').val($(this).find(':selected').val());
        $('#city_select_container').hide();
        });
        })###;