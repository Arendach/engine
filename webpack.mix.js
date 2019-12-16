const mix = require('laravel-mix')

mix.config.fileLoaderDirs.fonts = 'public/fonts';

mix.webpackConfig({
    module: {
        rules: [
            {test: /\.coffee$/, loader: 'coffee-loader'}
        ]
    }
})

mix.options({
    processCssUrls: false
})

// mix.sourceMaps()

mix.js('src/coffee/app.coffee', 'public/js/app.js')
    .js('src/coffee/login.coffee', 'public/js/login.js')
    .js('src/coffee/orders/orders.coffee', 'public/js/controllers/orders.js')
    .less('src/less/login.less', 'public/css/login.css')
    .less('src/less/app.less', 'public/css/app.css')
    .less('src/less/print.less', 'public/css/print.css')


    // themes
    .less('src/less/themes/cerulean.less', 'public/css/themes/cerulean.css')
    .less('src/less/themes/cosmo.less', 'public/css/themes/cosmo.css')
    .less('src/less/themes/cyborg.less', 'public/css/themes/cyborg.css')
    .less('src/less/themes/darkly.less', 'public/css/themes/darkly.css')
    .less('src/less/themes/flatfly.less', 'public/css/themes/flatfly.css')
    .less('src/less/themes/yeti.less', 'public/css/themes/yeti.css')
    .less('src/less/themes/paper.less', 'public/css/themes/paper.css')