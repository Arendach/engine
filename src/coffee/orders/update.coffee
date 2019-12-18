$(document).on 'submit', '#load_photo', (event) ->
    event.preventDefault();

    if typeof files is 'undefined' then return

    data = new FormData()

    $.each files, (key, value) -> data.append key, value

    data.append 'action', 'load_photo'
    data.append 'id', window.JData.id

    $.ajax
        type: 'post'
        url: 'orders/upload_file'
        data
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