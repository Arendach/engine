<?php
$CSS_COMPONENTS = '';
$JS_COMPONENTS = '';
$array_components = [
    'breadcrumbs',
    'sweet_alert',
    'modal', 'bootstrap',
    'font_awesome',
    'jquery',
    'color_picker',
    'ajax_upload',
    'summer_note',
    'calendar',
    'inputmask'
];

$array_components_default = ['bootstrap', 'font_awesome', 'sweet_alert', 'breadcrumbs'];

if (isset($components)) {
    foreach ($array_components_default as $item)
        array_push($components, $item);
} else {
    $components = $array_components_default;
}

$components = array_unique($components);
$template_object = new \Web\App\TemplateComponents();
if (is_array($components)) {
    foreach ($components as $component) {
        if (in_array($component, $array_components) || in_array($component, $array_components_default)) {
            if (method_exists($template_object, $component)) {
                $object_component = $template_object->$component();
                $CSS_COMPONENTS .= isset($object_component['css']) ? $object_component['css'] . PHP_EOL : '';
                $JS_COMPONENTS .= isset($object_component['js']) ? $object_component['js']. PHP_EOL : '';
            } else {
                Web\App\Log::error("Компонент \"{$component}\" не зареєстровано в класі \"\Web\App\TemplateComponents\"! ", 'template_error');
            }
        } else {
            \Web\App\Log::error("Компонент \"{$component}\" не зареєстровано в глобальному масиві компонентів! ", 'template_error');
        }
    }
} elseif (is_string($components)) {
    if (in_array($components, $array_components) || in_array($components, $array_components_default)) {
        if (method_exists($template_object, $components)) {
            $object_component = $template_object->$components();
            $CSS_COMPONENTS .= isset($object_component['css']) ? $object_component['css']. PHP_EOL : '';
            $JS_COMPONENTS .= isset($object_component['js']) ? $object_component['js']. PHP_EOL : '';
        } else {
            Web\App\Log::error("Компонент \"{$components}\" не зареєстровано в класі \"TemplateComponents\"! ", 'template_error');
        }
    } else {
        \Web\App\Log::error("Компонент \"{$components}\" не зареєстровано в глобальному масиві компонентів! ", 'template_error');
    }
}
unset($array_components);
unset($array_components_default);
unset($template_object);

