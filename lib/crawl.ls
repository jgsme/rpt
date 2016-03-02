require! {
  request
}

url-gen = (id, is-limit = true)->
  base = "http://api.tumblr.com/v2/blog/#{id}/posts/photo?api_key=#{process.env.TUMBLR_API_KEY}"
  if is-limit
    "#{base}&limit=1"
  else
    base

posts-resolver = (body, opts)->
  JSON.parse body .response.posts.map (post)->
    switch opts.size
    | \1280 => post.photos.0.alt_sizes.0.url
    | \500  => post.photos.0.alt_sizes.1.url
    | otherwise => post.photos.0.original_size.url

_crawl = (id, opts, resolve, reject)->
  if opts.offset?
    err, _, body <- request "#{url-gen id, false}&offset=#{opts.offset}"
    resolve posts-resolver body, opts
  else
    err, _, body <- request url-gen id
    body = JSON.parse body
    if body.meta.status is 200
      total = parseInt body.response.total_posts
      url = if opts.is-all then url-gen id, false else url-gen id
      err, _, body <- request "#{url}&offset=#{Math.floor(Math.random() * total)}"
      if opts.is-all
        resolve posts-resolver body, opts
      else
        resolve (JSON.parse body).response.posts.0.photos.0.original_size.url
    else
      if id.match /\.tumblr\.com/
        reject!
      else
        _crawl "#{id}.tumblr.com", opts, resolve, reject

crawl = (id, opts = {})->
  new Promise (resolve, reject)-> _crawl id, opts, resolve, reject

module.exports = crawl
