import React, { Component } from 'react';
import { connect }          from 'react-redux';


export default class Footer extends Component {
  render() {
    return (
      <footer>
        <p>
          Footer
        </p>
      </footer>
    );
  }
}

const mapStateToProps = (state) => {
  return {}
};

export default connect(mapStateToProps)(Footer);
