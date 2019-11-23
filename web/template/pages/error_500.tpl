<html>
<head>
    <style type="text/css">
        * {
            margin: 0;
            padding: 0;
        }

        body {
            text-align: center;
            background: #2B2B2B;
        }

        div {
            display: inline-block;
            text-align: center;
            width: 800px;
            height: 50%;
            background: #555;
            margin-top: 10%;
            margin-bottom: 10%;
            color: #fff;
            padding: 20px;
        }
</style>
</head>
<body>
<div>
    <h1>Внутрішня помилка сервера!</h1>
    <br>
    <?= isset($message) && $message !== false ? '<h3>' . $message . '</h3>' : '' ?>
</div>
</body>
</html>
