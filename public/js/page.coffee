vm = new Vue
  el: '#main'
  data:
    id: /^\/p\/(.*)/.exec(location.pathname)[1]
  ready: ->
    $.get "/r/#{@.$data.id}"
      .done (url)=>
        @.$data.url = url
  computed:
    md: -> "![#{@.$data.id}](#{@.$data.url})"
