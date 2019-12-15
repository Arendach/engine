$(document).ready ->
    button = $ '#image_upload'
    new AjaxUpload button,
        action: '/products/upload_image'
        name: 'image_upload'
        data: {id: id}
        onComplete: (file, a) ->
        try
            answer = JSON.parse a
            if answer.status is '1'
                $('.thumbnail_img').append '<div class="img_wrap">
                    <img src="' + answer.url + '" class="img-thumbnail" height="200px">
                    <span data-path="' + answer.url + '" class="deleteImg">X</span>
                    </div>'
                swal
                    title: "Виконано"
                    type: "success"
                    text: answer.message
            else
                swal
                    title: "Помилка",
                    type: "error",
                    text: answer.message
        catch err
            swal
                title: "Невідома помилка!"
                type: "error"

$(document).on 'click', '.delete_image', ->
    src = $(this).attr 'data-src'

    swal
        title: "Дійсно видалити?"
        text: "Відмінити дію буде неможливо!"
        type: "warning"
        showCancelButton: true
        confirmButtonColor: "#DD6B55"
        confirmButtonText: "Видалити!"
        closeOnConfirm: false
        html: false
    , ->
        $.ajax
            type: 'post'
            url: '/delete_temp_file'
            data: {path: src}
            success: (answer) -> successHandler answer
            error: (answer) -> errorHandler answer

$(document).on 'click', '#update-attribute', (event) ->
    event.preventDefault()
    attribute = {}

    $('input.attribute').each ->
        name = $(this).attr 'data-name'
        if Array.isArray attribute[name]
            attribute[name].push $(@).val()
        else
            attribute[name] = [];
            attribute[name].push $(@).val()
    
    $.ajax
        type: 'post',
        url: url('/products/update'),
        data:
            id: id
            method: 'attribute'
            data: attribute
        success: (answer) -> successHandler answer
        error: (answer) -> errorHandler answer


$(document).on 'keyup', '#search_characteristic', ->
    value = $(@).val()
    if value is ''
        return $('.characteristic_search_result').html ''
    
    notIn = []
    $('.characteristic').each -> notIn.push $(@).data 'id'
    
    $.ajax
        type: 'post',
        url: url('product'),
        data:
            action: 'search_characteristics',
            name: value,
            not: notIn
        success: (answer) -> $('.characteristic_search_result').html answer
 

$(document).on 'click', '.get_searched_characteristic', ->
    
    $.ajax
        type: 'post'
        url: '/product'
        data:
            action: 'get_searched_characteristic'
            id: $(@).data('id')
        success: (answer) =>
            $ '.characteristics'
                .prepend answer
            $(@).remove()
        error: (answer) -> errorHandler(answer)

        
$(document).on 'click', '.delete_characteristic', ->
    $(@).parents('.characteristic').fadeOut().remove()

$(document).on 'click', '.close_characteristic_search_result', ->
    $ '#search_characteristic'
        .val ''
    
    $ '.characteristic_search_result'
        .html ''