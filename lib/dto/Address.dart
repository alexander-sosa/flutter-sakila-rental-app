class Address{
  int _address_id;
  String _address;
  String _address2;
  String _district;
  String _city;
  int _city_id;
  String _country;
  String _postal_code;
  String _phone;
  String _location;

  Address();

  String get location => _location;

  set location(String value) {
    _location = value;
  }

  String get phone => _phone;

  set phone(String value) {
    _phone = value;
  }

  String get postal_code => _postal_code;

  set postal_code(String value) {
    _postal_code = value;
  }

  String get country => _country;

  set country(String value) {
    _country = value;
  }

  int get city_id => _city_id;

  set city_id(int value) {
    _city_id = value;
  }

  String get city => _city;

  set city(String value) {
    _city = value;
  }

  String get district => _district;

  set district(String value) {
    _district = value;
  }

  String get address2 => _address2;

  set address2(String value) {
    _address2 = value;
  }

  String get address => _address;

  set address(String value) {
    _address = value;
  }

  int get address_id => _address_id;

  set address_id(int value) {
    _address_id = value;
  }
}