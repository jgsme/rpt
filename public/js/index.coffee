vm = new Vue
  el: '#jump'
  data:
    id: /^\/p\/(.*)/.exec(location.pathname)?[1] || ''
  methods:
    go: ->
      location.href = "/p/#{@.$data.id}"
    checkEnter: (event)->
      if event.keyCode is 13 then @go()
