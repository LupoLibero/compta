import { Meteor } from 'meteor/meteor'
import { actionTypeBuilder } from '../utils/actionTypeBuilder'
import { Entries } from '../api/entries/entries'

export const ENTRIES = actionTypeBuilder.type('ENTRIES')

export function getEntries() {
  return dispatch => {
    //dispatch(myOnloadingAction())
    dispatch({
      type: ENTRIES,
      meteor: {
        subscribe: () => Meteor.subscribe('entries.list'),
        get:       () => Entries.find().fetch()
      }
    })
  }
}
