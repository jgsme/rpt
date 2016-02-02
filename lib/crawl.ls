require! {
  request
}

url = (id)-> "http://api.tumblr.com/v2/blog/#{id}/posts/photo?api_key=#{process.env.TUMBLR_API_KEY}&limit=1"

_crawl = (id, resolve, reject)->
  err, _, body <- request url id
  body = JSON.parse body
  if body.meta.status is 200
    total = parseInt body.response.total_posts
    err, _, body <- request "#{url(id)}&offset=#{Math.floor(Math.random() * total)}"
    resolve (JSON.parse body).response.posts.0.photos.0.original_size.url
  else
    if id.match /\.tumblr\.com/
      reject!
    else
      _crawl "#{id}.tumblr.com", resolve, reject

crawl = (id)->
  new Promise (resolve, reject)-> _crawl id, resolve, reject

module.exports = crawl
