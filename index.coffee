express = require 'express'
request = require 'request'
coffee = require 'coffee-middleware'
stylus = require('stylus').middleware
app = express()

url = (id)-> "http://api.tumblr.com/v2/blog/#{id}/posts/photo?api_key=#{process.env.TUMBLR_API_KEY}&limit=1"
crawl = (id, callback)->
  request url(id), (err, r, body)->
    body = JSON.parse body
    if body.meta.status is 200
      total = body.response.total_posts
      request "#{url(id)}&offset=#{Math.floor(Math.random() * total)}", (err, r, body)->
        callback JSON.parse(body).response.posts[0].photos[0].original_size.url
    else
      if id.match(/\.tumblr\.com/)
        callback null
      else
        crawl "#{id}.tumblr.com", callback

app.set 'views', "#{__dirname}/views"
app.set 'view engine', 'jade'
app.use coffee
  src: "#{__dirname}/public"
app.use stylus
  src: "#{__dirname}/public"
app.use express.static("#{__dirname}/public")

app.get '/', (req, res)->
  crawl 'spacesushipic', (url)->
    if url is null
      res.status(404).send 'Not found'
    else
      res.render 'index',
        url: url
app.get '/p/:id', (req, res)->
  crawl req.params.id, (url)->
    if url is null
      res.status(404).send 'Not found'
    else
      res.render 'index',
        url: url
app.get '/r/:id', (req, res)->
  crawl req.params.id, (url)->
    if url is null
      res.status(404).send 'Not found'
    else
      res.redirect url

server = app.listen process.env.PORT || 3000, -> console.log "Server start at port: #{server.address().port}"
