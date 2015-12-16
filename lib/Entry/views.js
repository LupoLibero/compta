exports.entry_all = {
  map: function(doc) {
    if(doc.type == 'entry') {
      emit(doc.date, null);
    }
  },
}