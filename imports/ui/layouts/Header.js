import React       from 'react';
import { connect } from 'react-redux';

function Header(props) {
  return (
    <nav>
      <div className="nav-wrapper">
        <a href="#" className="brand-logo">CanapERP</a>
        <ul id="nav-mobile" className="right hide-on-med-and-down">
          {/*<li><a href="sass.html">Sass</a></li>*/}
        </ul>
      </div>
    </nav>
  );
}

const mapStateToProps = (state) => {
  return {
  }
};

export default connect(mapStateToProps)(Header);
