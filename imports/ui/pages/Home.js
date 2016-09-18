import React       from 'react';
import { connect } from 'react-redux';

const Home = ({ entries }) => (
  <div>
    test
    <br />
    <br />
    <div className="row">
      <div className="col-xs-2">Date</div>
      <div className="col-xs-4">Titre</div>
      <div className="col-xs-2">Montant</div>
    </div>
    {entries.map(entry =>
      <div className="row" key={entry._id}>
        <div className="col-xs-2">{entry.date.toLocaleDateString()}</div>
        <div className="col-xs-4">{entry.title}</div>
        <div className="col-xs-2">{entry.amount}</div>
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
