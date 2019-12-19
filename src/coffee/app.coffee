# jQuery
$ = require 'jquery'
window.$ = $
window.jQuery = $

# Global
window.Inputmask = require 'inputmask'
window.toastr = require 'toastr'
window.swal = require 'sweetalert2'
window.URI = require 'urijs'
window.UrlGenerator = require './UrlGenerator.coffee'

# jQuery plugins
require 'bootstrap'
require 'jquery.cookie'
require 'jquery-serializejson'
require 'bootstrap-3-typeahead'
require 'select2'
window.$.fn.select2.defaults.set "theme", "bootstrap"


# Custom scripts
require './common.coffee'