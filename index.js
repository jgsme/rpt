const {parse, URLSearchParams} = require('url')
const request = require('request')
const base64 = require('node-base64-image')
const {promisify} = require('util')
const encode = promisify(base64.encode)
const {TUMBLR_API_KEY} = process.env

const urlGen = ({id, isLimit = true}) => {
  let base =
    `http://api.tumblr.com/v2/blog/${id}/posts/photo?api_key=${TUMBLR_API_KEY}`
  return isLimit ? `${base}&limit=1` : base
}

const postResolver = ({body, opts = {}}) => {
  return JSON.parse(body).response.posts.map(post => {
    const {photos} = post
    const ran = Math.floor(Math.random() * photos.length)
    switch (opts.size) {
      case '1280': return photos[ran].alt_sizes[0].url
      case '500': return photos[ran].alt_sizes[1].url
      default: return photos[ran].original_size.url
    }
  }).pop()
}

const crawl = ({id, opts = {}}) => new Promise((resolve, reject) => {
  if (opts.offset !== undefined) {
    request(`${urlGen({id})}&offset=${opts.offset}`, (err, res, body) => {
      if (err) {
        return reject(err)
      }
      resolve()
    })
  } else {
    request(`${urlGen({id})}`, (err, res, body) => {
      if (err) {
        return reject(err)
      }
      body = JSON.parse(body)
      if (body.meta.status === 200) {
        const total = parseInt(body.response.total_posts)
        const url = opts.isAll ? urlGen({id, isLimit: false}) : urlGen({id})
        request(
          `${url}&offset=${Math.floor(Math.random() * total)}`, (e, r, b) => {
            if (e) {
              return reject(e)
            }
            return resolve(postResolver({body: b, opts}))
          }
        )
      } else {
        return reject(new Error(`Tumblr API returns ${body.meta.status}`))
      }
    })
  }
})

module.exports = async (req, res) => {
  try {
    const url = parse(req.url)
    res.statusCode = 200
    res.setHeader('Access-Control-Allow-Origin', '*')
    res.setHeader('Access-Control-Allow-Methods', 'GET')
    switch (url.pathname) {
      case '/': {
        res.setHeader('Content-Type', 'application/json')
        res.end('{"status": "ok"}')
        break
      }
      case '/p': {
        const params = new URLSearchParams(url.query)
        const u = await crawl({id: params.get('id')})
        res.setHeader('Content-Type', 'text/plain')
        res.end(u)
        break
      }
      case '/b': {
        const params = new URLSearchParams(url.query)
        const u = await crawl({id: params.get('id')})
        const image = await encode(u, {
          string: true
        })
        const ext = u.split('.').pop()
        res.setHeader('Content-Type', 'text/plain')
        res.end(`data:image/${ext};base64,${image}`)
        break
      }
    }
  } catch (err) {
    res.statusCode = 500
    res.setHeader('Content-Type', 'application/json')
    res.end('{"status": "Error"}')
    console.log(500, err)
  }
}
