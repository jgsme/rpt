import 'livescript'
import 'babel-polyfill'
import {readFileSync} from 'fs'
import {resolve} from 'path'
import Koa from 'koa'
import convert from 'koa-convert'
import cors from 'kcors'
import Jade from 'koa-jade'
import Router from 'koa-router'
import crawl from './lib/crawl.ls'
import {encode} from './lib/base64.ls'

const app = new Koa()
const router = new Router()
const jade = new Jade({
  viewPath: resolve(__dirname, './views'),
  debug: false,
  pretty: false,
  compileDebug: false,
  app: app
})

router
  .get('/', async (ctx) => {
    const url = await crawl('spacesushipic')
    ctx.render('index', {url})
  })
  .get('/p/:id', async (ctx) => {
    const url = await crawl(ctx.params.id)
    ctx.render('index', {url})
  })
  .get('/ps/:id', async (ctx) => {
    const urls = await crawl(ctx.params.id, {
      isAll: true,
      size: ctx.query.size,
      offset: ctx.query.offset
    })
    ctx.body = urls
  })
  .get('/r/:id', async (ctx) => {
    const url = await crawl(ctx.params.id)
    ctx.redirect(url)
  })
  .get('/b/:id', async (ctx) => {
    const url = await crawl(ctx.params.id)
    const image = await encode(url)
    const ext = url.split('.').pop()
    ctx.body = `data:image/${ext};base64,${image}`
  })
  .get('/assets/:filename', async (ctx) => {
    switch (ctx.params.filename) {
      case 'index.js': {
        ctx.body = readFileSync(resolve(__dirname, './build/index.js')).toString()
        ctx.set('Content-Type', 'text/javascript; charset=utf-8')
        break
      }
      case 'index.css': {
        ctx.body = readFileSync(resolve(__dirname, './build/index.css')).toString()
        ctx.set('Content-Type', 'text/css; charset=utf-8')
        break
      }
      default: {
        ctx.body = ''
        ctx.status = 404
      }
    }
  })

app
  .use(async (ctx, next) => {
    try {
      await next()
    } catch (err) {
      console.error(err.stack)
      ctx.body = {
        message: err.message
      }
      ctx.status = err.status || 500
    }
  })
  .use(convert(cors()))
  .use(router.routes())
  .use(router.allowedMethods())

app.listen(process.env.PORT || 3000)
