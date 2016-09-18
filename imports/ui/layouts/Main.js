import React, { Component } from 'react';
import { connect } from 'react-redux';

const Main = ({ content }) => (
  <div className="main">
    {content}
  </div>
);

const mapStateToProps = (state) => {
  return {
  }
};


export default connect(mapStateToProps)(Main);
