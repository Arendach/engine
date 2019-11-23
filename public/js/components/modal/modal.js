/**
 * Відкрити модальне вікно
 */

function myModalOpen(html) {
    $('body').append(html);
    $('.modal').modal();
}

/**
 * Закрити модальне вікно
 */

function myModalClose() {
    $('.poster').css('z-index', '-1').animate({opacity: 0}, 400);
    $('#modal').css('z-index', '1').animate({opacity: 0}, 400);
    $('#content').css('display', 'block');
    $('#left_bar').css('display', 'block');
    setTimeout(function () {
        $('#modal').css('display', 'none');
    }, 400);
}

/**
 * Обробник події (натиснута кнопка закрити)
 */
$(document).on('click', '#modal_close', myModalClose);
$(document).on('click', '.poster', myModalClose);

$(document).keydown(function (eventObject) {
    if (eventObject.which == 27) myModalClose();
});

