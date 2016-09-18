import { Meteor }       from 'meteor/meteor'
import { Mongo }        from 'meteor/mongo'
import { SimpleSchema } from 'meteor/aldeed:simple-schema';

export const Entries = new Mongo.Collection('entries')

Entries.deny({
  insert() { return true; },
  update() { return true; },
  remove() { return true; },
});

Entries.schema = new SimpleSchema({
  //_id:       { type: String, regEx: SimpleSchema.RegEx.Id },
  date:      { type: Date, },
  title:     { type: String, },
  execDate:  { type: Date, optional: true }, //TODO: update by sync bot only
  amount:    { type: Number, decimal: true },
  category:  { type: String, optional: true },
})

Entries.attachSchema(Entries.schema)
