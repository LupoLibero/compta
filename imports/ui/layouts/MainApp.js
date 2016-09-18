import React, { Component } from 'react';
import Main     from './Main';
import Header   from './Header';
import Footer   from './Footer';
import DevTools from '../components/DevTools';

export default class MainApp extends Component {
  render() {
    const DevToolsComponent = <DevTools />;

    return (
      <div>
        {DevToolsComponent}
        <Header   />
        <Main     />
        <Footer   />
      </div>
    )
  };
}
