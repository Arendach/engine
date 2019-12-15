config =
    basic:
        toolbarGroups: [
            {name: 'document', groups: ['mode', 'document', 'doctools']}
            {name: 'clipboard', groups: ['clipboard', 'undo']}
            {name: 'editing', groups: ['find', 'selection', 'spellchecker']}
            {name: 'forms'}
            {name: 'basicstyles', groups: ['basicstyles', 'cleanup']}
            {name: 'paragraph', groups: ['list', 'indent', 'blocks', 'align', 'bidi']}
            {name: 'links'}
            {name: 'insert'}
            {name: 'styles'}
            {name: 'colors'}
            {name: 'tools'}
            {name: 'others'}
            {name: 'about'}
        ]
        removeButtons: 'Cut,Copy,Paste,Undo,Redo,Anchor,Underline,Strike,Subscript,Superscript'
        removeDialogTabs: 'link:advanced'

module.exports = config