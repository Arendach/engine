
filterOrders ->
    data = {}
    $('.search').each((i, e) -> data[$(e).attr('id')] = $(e).val())
    GET.setObject(data).unsetEmpty().unset('page').go()


$(document).on 'click change', '#search, select.search', filterOrders


$(document).on 'keyup', '.search', (e) ->
    if e.which == 13
        do filterOrders


$(document).on 'click', '#export_xml', ->
    ids = [];
    $('.order_check:checked').each((index, element) => ids.push($(element).data('id')))

    if not ids.length
        return alert 'Ви не позначили жодного замовлення для експотування!'

    $.ajax
        type: 'post',
        url: '/orders/export',
        data: {ids}
        success: answer -> successHandler(answer)


$(document).on 'click', '.print_button', ->
    $this = $(@)
    $print = $($this.data('id'))

    $(".buttons:not(.buttons#{$this.data('id')})").hide()

    if ($print.css('display') == 'none') $print.show()
    else $print.hide()


$(document).on 'change', '.courier', ->
    order_id = $(@).parents('tr').attr('id')
    courier_id = $(@).find(':selected').val()

    $.ajax
        type: 'post'
        url: '/orders/update_courier'
        data: {order_id, courier_id},
        success: answer -> successHandler(answer, true)
        error: answer -> errorHandler(answer)


$(document).on 'click', '.preview', ->
    $parent = $(@).parents 'tr'
    $preview_container = $parent.find '.preview_container'
    id = $parent.attr 'id'

    if $preview_container.html() isnt ''
        return $preview_container.html ''

    $('.preview_container').each (index, element) -> $(element).html('')

    $.ajax
        type: 'post'
        url: '/orders/preview'
        data: {id}
        success: (answer) -> $preview_container.html(answer)
        error: (answer) -> errorHandler(answer)


$(document).on 'click', '#route_list', ->
    url = ''
    $('.order-row').each (i, e) -> url += ':' + $(e).attr('id')

    window.open "/orders/route_list?ids=#{url}", '_blank'


$(document).on 'click', '#more_filters', -> $('.filter_more').toggleClass 'none'


$(document).ready ->
    $('.search#phone').inputmask '999-999-99-99'
    $('#phone').inputmask "999-999-99-99"
    $('#phone2').inputmask "999-999-99-99"
