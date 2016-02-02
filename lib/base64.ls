require! {
  \node-base64-image : {base64encoder}
}

exports.encode = (url)->
  new Promise (resolve, reject)->
    err, image <- base64encoder url, {string: true}
    if err?
      return reject err
    resolve image
