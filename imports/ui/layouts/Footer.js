import React, { Component } from 'react';
import { connect }          from 'react-redux';


export default class Footer extends Component {
  render() {
    return (
      <footer className="page-footer">
        <div className="container">
          <div className="row">
            <div className="col s12">
              <h5 className="white-text">Footer</h5>
            </div>
          </div>
        </div>
        <div className="footer-copyright">
          
        </div>
      </footer>
    );
  }
}

const mapStateToProps = (state) => {
  return {}
};

export default connect(mapStateToProps)(Footer);
