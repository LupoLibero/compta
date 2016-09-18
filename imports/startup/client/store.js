import { applyMiddleware, createStore, compose } from 'redux';
import createLogger      from 'redux-logger';
import ReduxThunk        from 'redux-thunk';
import rootReducer       from '/imports/reducers';
import promiseMiddleware from 'redux-promise-middleware';

import { meteorMethod, meteorSubscription } from "meteor/shawnmclean:redux-meteorware";

import DevTools from '/imports/ui/components/DevTools';
import {
  newSuccessNotification,
  newErrorNotification
} from '/imports/actions/notifications'


let middlewares = [
  ReduxThunk,
  promiseMiddleware(),
  meteorSubscription,
  createLogger()
];

const enhancers = [
  applyMiddleware(...middlewares),
  DevTools.instrument()
];

const initialState = {};

const Store = createStore(rootReducer, initialState, compose(...enhancers));

export default Store;
