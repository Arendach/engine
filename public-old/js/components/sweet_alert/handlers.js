function delete_on_click(func) {
    swal({
        title: "Видалити?",
        text: "Дану дію відмінити буде неможливо!",
        type: "warning",
        showCancelButton: true,
        confirmButtonColor: "#DD6B55",
        confirmButtonText: "Так, я хочу видалити!",
        closeOnConfirm: false
    }, func);
}

function pin_code(func) {
    swal({
        title: "Необхідний пін-код!",
        type: "input",
        inputType: "password",
        showCancelButton: true,
        closeOnConfirm: false,
        inputPlaceholder: ""
    }, function (inputValue) {
        if (inputValue === false) return false;
        if (inputValue != pin) {
            swal.showInputError("Пін-код не вірний!");
            return false
        }

        swal.close();
        setTimeout(func, 100);

        return true;
    });
}

function errorHandler(response) {
    try {
        var answer = JSON.parse(response.responseText);
        var message = answer.message !== undefined ? answer.message : 'Невідома помилка!';
        swal({
            type: 'error',
            text: message,
            title: 'Помилка',
            html: true
        });
    } catch (err) {
        swal({
            type: 'error',
            text: response.responseText,
            title: 'Помилка',
            html: true
        });
    }
}

function successHandler(response, func) {
    try {
        if (func === undefined) {
            func = function () {
                location.reload();
            };
        } else if (func === true) {
            func = function () {
                swal.close();
            };
        }

        var answer = JSON.parse(response);
        var message = answer.hasOwnProperty('message') ? answer.message : 'Всі дані збережено!';

        var action = answer.hasOwnProperty('action') ? answer.action : 'reload';

        if (action == 'redirect') {
            func = function () {
                window.location.href = answer.uri;
            }
        } else if (action == 'reload') {
            func = function () {
                location.reload();
            };
        } else if (action == 'close') {
            func = function () {
                swal.close();
            };
        } else if (action == 'function') {
            func = function () {
                eval(answer.function);
            }
        }

        var type = 'success';

        if (answer.hasOwnProperty('alert_type'))
            type = answer.alert_type;

        swal({
            type: type,
            html: true,
            text: message,
            title: 'Виконано',
            closeOnConfirm: false
        }, func);

    } catch (err) {
        elog(response);
        swal({
            type: 'error',
            text: response,
            title: 'Помилка',
            html: true
        });
    }
}