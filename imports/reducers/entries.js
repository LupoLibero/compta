import { actionTypeBuilder } from '/imports/utils/actionTypeBuilder'
import { ENTRIES } from '../actions/entries'

const initialState = {
  data: []
}

export default function entriesReducer(state = initialState, action = {}) {
  const { data, ready, type } = action;
  switch (type) {
    case actionTypeBuilder.ready(ENTRIES):
      return Object.assign({}, state, { ready })
    case actionTypeBuilder.changed(ENTRIES):
      return Object.assign({}, state, { data })
    default:
      return state;
  }
}
