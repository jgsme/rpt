rpt
===
[![Dependency Status](https://david-dm.org/jgsme/rpt.png)](https://david-dm.org/jgsme/rpt)
[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)

random photo from tumblr

# Usage

## GET `/`

* alias `/p/spacesushipic`

## GET `/p/:id`

![](https://cloud.githubusercontent.com/assets/557961/4514559/841ec580-4b77-11e4-9c11-9c3bf44546c9.png)

* show image url
* markdown sentence for paste image
* image preview

## GET `/r/:id`

* redirect image url

# Requirements

* Tumblr Api key

```
% heroku config:add TUMBLR_API_KEY=$YOURKEY
```

# Author

* jigsaw (http://jgs.me)

# License

MIT
