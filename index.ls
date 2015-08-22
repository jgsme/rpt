require! {
  hapi: Hapi
  vision: Vision
  inert: Inert
  jade
  \./lib/crawl.ls
}

server = new Hapi.Server!
  ..connection do
    port: process.env.PORT or 8080

err <- server.register Inert
err <- server.register Vision

if err?
  console.log err
  process.exit 1

handle = (id, rep, isRedirect = false)->
  url <~ crawl id
  if url is null
    rep 'Not found' .code 404
  else
    if isRedirect
      rep.redirect url
    else
      rep.view do
        \index
        url: url

server
  ..views do
      engines:
        jade: jade
      path: "#{__dirname}/views"
      compileOptions:
        pretty: true
  ..route do
      method: \GET
      path: '/static/{param*}'
      handler:
        directory:
          path: "#{__dirname}/build"
  ..route do
      method: \GET
      path: \/
      handler: (req, rep)-> handle \spacesushipic, rep
  ..route do
      method: \GET
      path: '/p/{id}'
      handler: (req, rep)-> handle req.params.id, rep
  ..route do
      method: \GET
      path: '/r/{id}'
      handler: (req, rep)-> handle req.params.id, rep, true
  ..start -> console.log "Server running at: #{server.info.uri}"
