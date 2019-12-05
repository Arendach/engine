$(document).on 'click', "#find_products", ->
    manufacturer = $('#manufacturer').val
    storage = $('#storage').val
    category = $('#category').val

    return alert('Виберіть виробника!') if manufacturer is ''
    return alert('Виберіть склад!') if storage is ''

    $.ajax
        type: 'post'
        url: '/inventory'
        data:
            action: 'get_products',
            manufacturer: manufacturer,
            storage: storage,
            category: category
        success:  answer -> $('#place_for_products').html answer
        error: answer -> errorHandler answer

$(document).on 'submit', '#inventory_create', event ->
    event.preventDefault
    
    products = {}

    $('.amount').each ->
        if ($(@).val() != '')
            products[$(@).parents('tr').data 'id'] = $(@).val

    $.ajax
        type: 'post'
        url: '/inventory'
        data:
            action: 'create'
            products: products
            manufacturer: $('#manufacturer').val
            storage: $('#storage').val
            comment: $('#comment').val
        success:  answer -> successHandler answer
        error: answer -> errorHandler answer
