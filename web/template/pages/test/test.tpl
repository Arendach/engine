<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Document</title>

    <style>
        div.background {
            height: 200px;
            background: url(https://cdn-images-1.medium.com/max/2000/1*AcYLHh0_ve4TNRi6HLFcPA.jpeg) top center no-repeat fixed;
            position: absolute;
            width: 100%;
            z-index: -1;
        }

        * {
            margin: 0;
            padding: 0;
        }
    </style>
</head>
<body>

<script>
    $(document).on('click', '.symptom-list li', function () {
        $(this).toggleClass("active");

        var sum = 0;
        $.each('.symptom-list li.active', function () {
            sum += parseInt($(this).attr('data'));
        });

        $('#result').html(sum);
    });
</script>
</body>
</html>