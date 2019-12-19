appendFiles = (element, data) ->
    $(element).each (index, element) ->
        data.append element.attr('')

$(document).on 'submit', '#upload_file', (event) ->
    event.preventDefault();

    data = new FormData()

    $(@).find('[name]').each (key, value) ->
        console.log $(@).attr('type')

        if $(@).attr('type') is 'file'
            data.append $(@).attr('name'), $(@).prop('files')[0]
            console.log $(@).prop('files')[0]
        else
            data.append $(@).attr('name') , value
            console.log value

    #return console.log(data)

    #data.append 'action', 'load_photo'
    #data.append 'id', window.JData.id

    $.ajax
        type: 'post'
        url: '/orders/upload_file'
        data: data
        cache: off
        dataType: 'json'
        # отключаем обработку передаваемых данных, пусть передаются как есть
        processData: off
        # отключаем установку заголовка типа запроса. Так jQuery скажет серверу что это строковой запрос
        contentType: off
        success: (answer, status, jqXHR)->
            new SuccessHandler answer, jqXHR
                .apply()
        error: (answer) ->
            new ErrorHandler answer
                .apply()

$(document).on 'change', '#file', (event) ->
    filename = $(this).val().replace(/.*\\/, "")
    $(".file-name").html(filename)