class User{
  int _user_id;
  int _store_id;
  String _last_name;
  String _first_name;
  String email;
  int _address_id;

  User();

  int get address_id => _address_id;

  set address_id(int value) {
    _address_id = value;
  }

  String get first_name => _first_name;

  set first_name(String value) {
    _first_name = value;
  }

  String get last_name => _last_name;

  set last_name(String value) {
    _last_name = value;
  }

  int get store_id => _store_id;

  set store_id(int value) {
    _store_id = value;
  }

  int get user_id => _user_id;

  set user_id(int value) {
    _user_id = value;
  }
}