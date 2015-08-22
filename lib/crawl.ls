require! {
  request
}

url = (id)-> "http://api.tumblr.com/v2/blog/#{id}/posts/photo?api_key=#{process.env.TUMBLR_API_KEY}&limit=1"

crawl = (id, callback)->
  err, _, body <- request url id
  body = JSON.parse body
  if body.meta.status is 200
    total = parseInt body.response.total_posts
    request do
      "#{url(id)}&offset=#{Math.floor(Math.random() * total)}"
      (err, _, body)-> callback do
                          JSON.parse body .response.posts.0.photos.0.original_size.url
  else
    if id.match /\.tumblr\.com/ then callback null else crawl "#{id}.tumblr.com", callback

module.exports = crawl
