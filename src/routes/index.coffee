# Require resume json
resume = require('../data/resume')

# GET home page.
exports.index = (req, res) ->
  res.render('index', resume)
