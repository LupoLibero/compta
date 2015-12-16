var types = require('./types');

exports.entry_add = function(doc, req) {
  var form = JSON.parse(req.body);
  if (!doc) {
    form.type     = 'entry';
    form._id      = req.uuid;
    form.createAt = new Date().getTime()
    form.amount   = parseFloat(form.amount)
    form.date     = parseInt(form.date)
    form.execDate = parseInt(form.date)
    for(var f in form) {
      if(!types.entry.fields.hasOwnProperty(f)) {
        delete form.f
      }
    }
    return [form, 'ok'];
  }
  throw({forbidden: 'Not for entry modification'});
}