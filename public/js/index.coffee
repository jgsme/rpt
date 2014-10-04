vm = new Vue
  el: '#jump'
  methods:
    go: ->
      location.href = "/p/#{@.$data.id}"
