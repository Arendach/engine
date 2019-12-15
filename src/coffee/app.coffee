# jQuery
jq = require 'jquery'
window.$ = jq
window.jQuery = jq

# bootstrap scripts
require 'bootstrap'
#require 'bootstrap-validator'

# Input-mask class
window.Inputmask = require 'inputmask'
window.toastr = require 'toastr'
window.swal = require 'sweetalert2'

# jQuery plugins
# require 'jquery-autocomplete'
#window.$.fn.autocomplete = require 'autocomplete.js'
require 'jquery.cookie'
require 'jquery-serializejson'
require 'bootstrap-3-typeahead'

window.URI = require 'urijs'
window.UrlGenerator = require './UrlGenerator.coffee'

window.editorConfig = require './editor.coffee'

require './common.coffee'
