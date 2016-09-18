import React       from 'react';
import { connect } from 'react-redux';

const Home = ({ entries }) => (
  <div className="entry-table">
    <br />
    <div className="row yellow">
      <div className="col s2">Date</div>
      <div className="col s4">Titre</div>
      <div className="col s2">Montant</div>
    </div>
    {entries.map((entry, i) =>
      <div className={"row " + (i % 2 ? "yellow lighten-4": "")} key={entry._id}>
        <div className="col s2">{entry.date.toLocaleDateString()}</div>
        <div className="col s4">{entry.title}</div>
        <div className="col s2">{entry.amount}</div>
      </div>
    )}
  </div>
);

const mapStateToProps = (state) => {
  return {
    entries: state.entries.data,
  }
};

export default connect(mapStateToProps)(Home);
