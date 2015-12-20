var Type              = require('couchtypes/types').Type;
var fields            = require('couchtypes/fields');
var permissions       = require('couchtypes/permissions');


var syncBotRole = '_admin';
var updateBySyncBotOnly = {
  update: permissions.hasRole(syncBotRole)
}

exports.entry = new Type('entry', {
  permissions: {
    //add:    permissions.hasRole(syncBotRole),  // created by sync from _users only
    //update: permissions.loggedIn(),
    remove: permissions.hasRole(syncBotRole)
  },
  fields: {
    date:               fields.number(),
    title:              fields.string(),
    execDate:           fields.number({
      required: false,
      permissions: updateBySyncBotOnly
    }),
    amount:             fields.number(),
    createdAt:          fields.createdTime(),
    category:           fields.string()
  },
});
