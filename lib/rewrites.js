module.exports = [
  {from: '/static/*', to: 'static/*'},
  {from: '/html/*',   to: 'html/*'},
  {from: '/_view/*',  to: '_view/*'},
  {from: '/_design/*',to: '../*'},
  {from: '/_doc/*',   to: '../../*'},
  {from: '/',         to: 'html/index.html'}
]
