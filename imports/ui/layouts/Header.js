import React       from 'react';
import { connect } from 'react-redux';

function Header(props) {
  return (
    <p>
      Header
    </p>
  );
}

const mapStateToProps = (state) => {
  return {
  }
};

export default connect(mapStateToProps)(Header);
