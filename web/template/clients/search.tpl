<table class="table">
    <tr>
        <td style="border-top: none">Імя</td>
        <td style="border-top: none">Едектронна пошта</td>
        <td style="border-top: none">Телефон</td>
    </tr>
    <?php foreach ($items as $client) { ?>
        <tr class="client_item" data-id="<?= $client->id ?>">
            <td><?= $client->name != '' ? $client->name : 'Не заповнено' ?></td>
            <td><?= $client->email != '' ? $client->email : 'Не заповнено' ?></td>
            <td><?= $client->phone != '' ? $client->phone : 'Не заповнено' ?></td>
        </tr>
    <?php } ?>
    <tr class="client_item" id="close_clients_search"><td class="centered text-danger" colspan="3">Відмінити</td></tr>
</table>
