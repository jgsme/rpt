express = require 'express'
app = express()

app.get '/', (req, res)-> res.send 'it works'

server = app.listen process.env.PORT || 3000, -> console.log "Server start at port: #{server.address().port}"
