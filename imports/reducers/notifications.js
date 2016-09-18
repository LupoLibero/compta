import { NEW_NOTIFICATION, CLEAR_NOTIFICATION } from '../actions/notifications';

export const initialState = {
  level: null,
  message: null,
};

export default function(state = initialState, action) {
  const { level, message, type } = action;

  switch (type) {
  case NEW_NOTIFICATION:
    return Object.assign({}, state, { level, message });

  case CLEAR_NOTIFICATION:
    return Object.assign({}, state, { level: null, message: null });

  default:
    return state;
  }
}
