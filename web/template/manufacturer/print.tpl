<body>
<div class="container-fluid">
    <div class="row">
        <div class="col-sm-12">
            <h4 class="sub-header" style='margin-bottom: 5rem;'><?php echo $section ?></h4>

            <div class="table-responsive">
                <table class="table table-bordered">
                    <thead>
                    <tr>
                        <th>Назва</th>
                        <th>E-Mail</th>
                        <th>Телефон</th>
                        <th>Адреса</th>
                        <th>Групи виробників</th>
                        <th>Інформація</th>
                    </tr>
                    </thead>
                    <tbody>
                    <?php foreach ($table as $key => $manuf): ?>
                        <tr>
                            <td><?php echo $manuf->name ?></td>
                            <td><?php echo $manuf->email ?></td>
                            <td><?php echo $manuf->phone ?></td>
                            <td><?php echo $manuf->address ?></td>
                            <td><?php echo $manuf->group_name ?></td>
                            <td><?php echo strip_tags($manuf->info) ?></td>
                        </tr>
                    <?php endforeach ?>
                    </tbody>
                </table>
            </div>

        </div>
    </div>
</div>
</body>