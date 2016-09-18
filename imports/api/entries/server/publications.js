import { Meteor } from 'meteor/meteor';

import { Entries } from '../entries'

Meteor.publish('entries.list', function entriesList() {
  return Entries.find()
})
