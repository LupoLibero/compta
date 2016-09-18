import { Meteor } from 'meteor/meteor';

import nodePath from 'path'

//import '../common/useraccounts-configuration.js';
import '../common/admin-configuration.js';
import './register-api.js';

if(Meteor.settings.MAIL_URL)
  process.env.MAIL_URL = Meteor.settings.MAIL_URL;


import { BankWeb } from 'meteor/bank-web'
import { BankStatementParser } from 'meteor/bank-statement-parser'

import { Entries } from '/imports/api/entries/entries'

const saveEntries = Meteor.bindEnvironment(
  (entries) => {
    console.log(entries.length)
    entries.forEach((entry) => {
      console.log("entry", entry)
      Entries.upsert(
        entry,
        {
          $set: entry
        }
      )
    })
  }
)

try {
  //BankWeb.get(saveEntries)
}
catch(error) {
  console.error(error)
}
const path = Assets.absoluteFilePath('statements/releve-201402.pdf')
const folder = nodePath.dirname(path)
//console.log(path)
try {
  //BankStatementParser.parseFile(folder, (entries, path) => { console.log(path, entries.length)})
} catch(error) {
  console.error(error)
}
