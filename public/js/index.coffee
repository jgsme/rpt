vm = new Vue
  el: '#main'
  methods:
    go: ->
      location.href = "/p/#{@.$data.id}"
