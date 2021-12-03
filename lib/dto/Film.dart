class Film{
  int _film_id;
  String _title;
  String _description;
  int _release_year;
  String _language;
  String _original_language;
  int _rental_duration;
  double _rental_rate;
  int _length;
  double _replacement_cost;
  String _rating;
  String _special_features;
  int _quantity;
  bool _selected;

  Film();

  int get quantity => _quantity;

  set quantity(int value) {
    _quantity = value;
  }

  String get special_features => _special_features;

  set special_features(String value) {
    _special_features = value;
  }

  String get rating => _rating;

  set rating(String value) {
    _rating = value;
  }

  double get replacement_cost => _replacement_cost;

  set replacement_cost(double value) {
    _replacement_cost = value;
  }

  int get length => _length;

  set length(int value) {
    _length = value;
  }

  double get rental_rate => _rental_rate;

  set rental_rate(double value) {
    _rental_rate = value;
  }

  int get rental_duration => _rental_duration;

  set rental_duration(int value) {
    _rental_duration = value;
  }

  String get original_language => _original_language;

  set original_language(String value) {
    _original_language = value;
  }

  String get language => _language;

  set language(String value) {
    _language = value;
  }

  int get release_year => _release_year;

  set release_year(int value) {
    _release_year = value;
  }

  String get description => _description;

  set description(String value) {
    _description = value;
  }

  String get title => _title;

  set title(String value) {
    _title = value;
  }

  int get film_id => _film_id;

  set film_id(int value) {
    _film_id = value;
  }

  bool get selected => _selected;

  set selected(bool value) {
    _selected = value;
  }
}