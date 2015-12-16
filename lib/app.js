var app = {
  language: 'javascript',
  updates: require('./updates'),
  views: require('./views'),
  rewrites: require('./rewrites'),
  validate_doc_update: require('./validate').validate_doc_update,
  types: require('./types'),
}
module.exports = app