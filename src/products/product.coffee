add_margin = ->
    if $('.search_combine_result').length > 0
        $('.search_combine_result').css 'margin-bottom', '15px'
    else
        $('.search_combine_result').css 'margin-bottom', '0px'

change_sum = ->
    sum = 0
    $('.combine_products_item').each ->
        amount = $(@).find('.amount').val()
        costs = $(@).find('.price').val()
        sum += +costs * +amount

    $('[name="costs"]').val(sum);
    add_margin();

$(document).on 'input', '.combine_products_item input', change_sum

$(document).on 'click', '.delete_combine_product', ->
    $(@).parents('.combine_products_item').remove()
    change_sum()

$(document).on 'click', '#close_search_combine_result',  ->
    $('.search_combine_result').html('');
    $('#search_products_to_combine').val('');


$(document).on 'change', '[name="combine"]',  ->
    if $(@).val()  $('.combine_wrapper').show()
    else $('.combine_wrapper').hide()

    
$(document).on 'keyup', '#search_products_to_combine',  ->
    value = $(@).val()
    notIn = []

    $('.combine_products_item').each -> notIn.push $(@).data 'id'
    
    $.ajax
        type: 'post'
        url: '/product'
        data:
            value: value,
            action: 'search_products_to_combine',
            not: notIn
        success: (answer) -> $('.search_combine_result').html answer
    

$(document).on 'click', '.get_product_to_combine', (event) ->
    event.preventDefault()

    id = $this.data 'id'

    $.ajax
        type: 'post'
        url: '/product'
        data:
            id: id,
            action: 'get_product_to_combine'
        success: (answer) =>
            $('.combine_products_list').prepend answer
            $(@).remove()
            change_sum()
    
    
filter_products = ->
    data = {}
    $('[data-action=search]').each ->
        data[$(@).data 'column'] = $(@).val()
    
    GET.setObject(data).unset('page').unsetEmpty().go()

    
$(document).on 'click', '#search',  filter_products


$(document).on 'keyup', '[data-action=search]', (event) ->
    if event.which == 13
        filter_products()


$(document).on 'change', 'select[data-action=search]', filter_products


$(document).on 'click', '.sort', (event) ->
    event.preventDefault()
    GET.set('order_field', $(@).data('field')).set('order_by', $(@).data('by')).go()


$(document).on 'click', '.copy', (event) ->
    event.preventDefault()
    amount = prompt 'Ведіть кількість копій!', '1'
    $.ajax
        type: 'post'
        url: '/product'
        data:
            id: id
            amount: amount
            action: 'copy'
        success: (answer) -> successHandler answer, -> window.location.href = '/product'
        error: (answer) -> errorHandler answer
        
$(document).on 'keyup', '#search_attribute',  ->
    $this = $(@);

    if $this.val().length is 0 or $this.val() is ''
        return $('.attribute_search_result').html ''

    $.ajax
        type: 'post'
        url: '/product'
        data:
            value: $this.val()
            action: 'search_attribute'
        success: (answer) -> $('.attribute_search_result').html answer
    

$(document).on 'click', '.get_searched_attribute', (event) ->
    event.preventDefault()

    $this = $(@)

    $.ajax
        type: 'post',
        url: '/product'
        data:
            id: $this.data('id')
            action: 'get_searched_attribute'
        success: (answer) ->
            $('#attribute_list').prepend(answer)
            $this.remove()
        error: (answer) -> errorHandler(answer)
    

$(document).on 'click', '.delete_attribute_variant',  ->
    if $(@).parents('.row').parent().find('.row').length > 2
        $(@).parents('.row').remove()


$(document).on 'click', '.add_attribute_value', (event) ->
    event.preventDefault()
    $input = $(@).parents('.panel-body').find('.row').last()
    $clone = $input.clone(true, true)
    $input.after($clone)

    
$(document).on 'click', '.close_attribute_search_result',  ->
    $('.attribute_search_result').html ''
    $('#search_attribute').val ''


$(document).on 'click', '.delete_attribute',  -> $(@).parents('.attribute_item').remove()


$(document).on 'keyup', '[name="volume[]"]',  ->
    sum = 1
    $('[name="volume[]"]').each -> sum *= +$(@).val()
    
    $('#volume').val sum / 1000000


$(document).on 'click', '.print_products',  ->
    url = {}
    $('[data-action=search]').each -> url[$(@).data 'column'] = $(@).val()
    
    url.section = 'print'

    GET.setObject(url).unsetEmpty().setDomain('/product').redirect()
    $(@).blur()


$(document).on 'click', '.pts_more',  ->
    id = $(@).data('id')

    $.ajax
        type: 'post'
        url:'product'
        data:
            action: 'pts_more'
            id: id
        success: (answer) -> $('.pts_more_' + id).html(answer).show()

$(document).on 'click', ':not(.pts_more_item)',  -> $('.pts_more_item').hide()


$(document).on 'click', '.more',  -> $('.filters').toggleClass 'none'


$(document).on 'click', '.filters_ok',  -> GET.set('items', $('[name=items]').val()).go()


$(document).on 'click', '.print_tick',  ->
    selected = Elements.getCheckedValues 'table', '.product_item'

    GET.setObject(
        section: 'print_tick'
        ids: selected.toString()
    ).redirect()


$(document).on 'click', '.print_stickers',  ->
    selected = Elements.getCheckedValues 'table', '.product_item'

    GET.setObject(
        section: 'print_stickers'
        ids: selected.toString()
    ).redirect()
