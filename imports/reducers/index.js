import { combineReducers } from 'redux';

import notifications from './notifications';
import entries       from './entries';

const rootReducer = combineReducers({
  notifications,
  entries
});

export default rootReducer;
