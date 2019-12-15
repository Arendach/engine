$(document).ready(function () {
    const api_key = '72e9482d68463c8d406a759d21c0ed13';

    $('button').on('click', function () {
        var params = {
            "apiKey": api_key,
            "modelName": "Address",
            "calledMethod": "searchSettlements",
            "methodProperties": {
                "CityName": "київ",
                "Limit": 5
            }
        };

        $.ajax({
            type: "POST",
            url: "http://api.novaposhta.ua/v2.0/json/",
            data: params,

        }).done(function (data) {
            console.log(data);
        });
    });
});