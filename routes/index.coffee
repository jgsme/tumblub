exports.index = (req, res)->
  res.render "index"

exports.show = require "./show"
exports.api = require "./api"
