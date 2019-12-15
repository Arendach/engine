document.ElementsExists = true

patterns =
    brackets: /\[\]$/
    bracketsSt: /\[\]\*$/

$(document).ready ->

$(document).on 'click', '.select > .option', -> $(@).toggleClass 'active'

$(document).on 'click', '.checkbox', ->  $(@).toggleClass 'active'

$(document).on 'click', '.check_all', ->
    active = no
    active = yes if $(@).hasClass('active')

    if $(@).data('parent')? then parent = $(@).parent()
    else parent = $(@).parents($(@).data 'parent')

    parent.find('.checkbox').each -> $(@).toggleClass('active', active)

window.Elements =
    selectElement: {}
    select: e ->
        @.selectElement = $(e)
        return @

    getMultiSelected: ->
        data = []
        @.selectElement.find('.active').each ->
            data.push $(@).data 'value'
        return data

    getMultiSelectedWithData: ->
        data = []
        @.selectElement.find('.active').each ->
            data.push $(@).data()
        return data

    getCheckbox: (element) -> $(element).hasClass 'active'

    formSerialize: (element) ->
        data = {}
        $(element).find('.checkbox').each ->
            name = $(@).data 'name'
            data[name] = $(@).hasClass 'active'

        $(element).find('.select').each ->
            name = $(@).data 'name'

            $(@).find('.active').each ->
                if not (name in data) then data[name] = []
                data[name].push $(@).data 'value'

        return data

    formSerializePush: (e, data) -> 1

    getCheckedValues: (element, n) ->
        n ?= '.checkbox'
        data = []
        $(element).find(n).each ->
            if $(@).hasClass 'active'
                data.push $(@).data 'value'

        return data

    customFormSerializePush: (d, f) ->
        $(f).find('.checkbox').each i ->
            name = $(@).data 'name'
            value = $(@).data 'value'
            key = $(@).data 'key'
            check = $(@).hasClass 'active'

            return if name?

            if name.match(patterns.brackets)
                if check
                    name = name.replace patterns.brackets, ''
                    if value isnt undefined
                        d[name].push(value)
            else if name.match patterns.bracketsSt
                name = name.replace patterns.bracketsSt, ''
                d[name][key ?= i] = value ?= check
            else
                d[name] = value ?= check

        $(f).find('.select').each ->
            name = $(@).data 'name'

            $(@).find('.option').each ->
                if $(@).hasClass 'active'
                    d[name].push $(@).data 'value'

        return d