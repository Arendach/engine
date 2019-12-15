class Modal
    constructor: (html) ->
        $('body').append html
        $('.modal').modal()
        @.handlers()
    
    handlers: ->
        $(document).on 'click', '#modal_close', @.myModalClose
        $(document).on 'click', '.poster', @.myModalClose
        $(document).on 'keydown', -> (event) ->
            if event.which is 27
                @.myModalClose()
    
    myModalClose: ->
        $('.poster').css('z-index', '-1').animate(opacity: 0, 400)
        $('#modal').css('z-index', '1').animate(opacity: 0, 400)
        $('#content').css('display', 'block')
        $('#left_bar').css('display', 'block')
        
        setTimeout -> $('#modal').css('display', 'none' , 400)