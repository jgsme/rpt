rpt
===
[![Dependency Status](https://david-dm.org/jgsme/rpt.png)](https://david-dm.org/jgsme/rpt)

random photo from tumblr

# Usage

## GET `/`

* alias `/p/spacesushipic`

## GET `/p/:id`

![](https://cloud.githubusercontent.com/assets/557961/4514559/841ec580-4b77-11e4-9c11-9c3bf44546c9.png)

* show image url
* markdown sentence for paste image
* image preview
 
## GET `/ps/:id`

* Return sevral image urls

### Query

* `size`: {500, 1280, (Empty)}, default: (Empty), If empty then return original size url
* `offset`: Number, default: (Empty), If empty then return random post's url

## GET `/r/:id`

* redirect image url

## GET `/b/:id`

* Return base64 encoded image

# Requirements

* Tumblr Api key

```
% export TUMBLR_API_KEY=$YOURKEY
```

# Author

* jigsaw (http://jgs.me)

# License

MIT
