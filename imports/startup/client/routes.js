import React          from 'react'
import { mount }      from 'react-mounter'
import { Provider }   from 'react-redux';
import { FlowRouter } from 'meteor/kadira:flow-router'
/*
import {
  pageNavigated,
  setDomain,
} from '/imports/actions/current'
import { getPages }      from '/imports/actions/pages'
import { getSections }   from '/imports/actions/sections'
*/
import { getEntries } from '/imports/actions/entries'

import Footer from '/imports/ui/layouts/Footer'
import Header from '/imports/ui/layouts/Header'
import Main   from '/imports/ui/layouts/Main'
import Home   from '/imports/ui/pages/Home'
import DevTools from '/imports/ui/components/DevTools';
import Store from './store';

function AppRoot({ content }) {
  return (
    <div className='top-container'>
      <Provider store={Store}>
        <div>
          <DevTools />
          <Header   />
          <Main content={content} />
          <Footer   />
        </div>
      </Provider>
    </div>
  );
}

FlowRouter.route('/', {
  name:          'app.domain.path',
  action:        () => {
    Store.dispatch(getEntries());
    mount(AppRoot, {
      content: <Home />
    })
  },
});
