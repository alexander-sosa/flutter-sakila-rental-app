class Store{
  String _country;
  int _country_id;
  int _store_id;

  Store();

  int get store_id => _store_id;

  set store_id(int value) {
    _store_id = value;
  }

  String get country => _country;

  set country(String value) {
    _country = value;
  }

  int get country_id => _country_id;

  set country_id(int value) {
    _country_id = value;
  }
}