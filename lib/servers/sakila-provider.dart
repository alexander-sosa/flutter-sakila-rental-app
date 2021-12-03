import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sakila_app/dto/Address.dart';
import 'package:sakila_app/dto/Film.dart';
import 'package:sakila_app/dto/Store.dart';
import 'package:sakila_app/dto/User.dart';
import 'package:sakila_app/main.dart';
import 'package:sakila_app/views/HomePage.dart';
import 'package:sakila_app/views/payment.dart';
import 'package:sakila_app/views/payments-response.dart';

class SakilaProvider extends ChangeNotifier{
  final String _rootUrl = 'http://10.0.2.2:8080';
  final _storage = new FlutterSecureStorage();

  // Stateful data
  List<Film> _allFilms = [];
  List<Film> _cart = [];
  User _userInProgress;

  // General data
  User _currentUser = User();
  Store _currentStore = Store();
  String _previous = "home";
  bool _loggedIn = false;

  // Purchase data
  double _original;
  double _discount;
  double _total;
  DateTime _returnDate;

  // functions
  void selectCountry(int country_id, String country, int store_id) async {
    this._currentStore.country = country;
    this._currentStore.country_id = country_id;
    this._currentStore.store_id = store_id;
    await _storage.write(key: 'country_id', value: country_id.toString());
    await _storage.write(key: 'store_id', value: store_id.toString());
    print("Info del pais y tienda guardada");
    notifyListeners();
  }

  Future<Map<int, String>> getCities() async {
    Map<int, String> cities = {};
    final response = await http.get(_rootUrl + "/address/city/${this._currentStore.country_id}");
    print('GET Cities status code:' + response.statusCode.toString());
    if(response.statusCode == 200){
      String body = utf8.decode(response.bodyBytes);
      final jsonData = json.decode(body);
      //print('All cities: ' + response.body);
      //print("First data: " + jsonData[0]['city']);
      for (var item in jsonData) {
        cities[item['city_id']] = item['city'];
      }
      //print("Map: $cities");
    }
    return cities;
  }

  User getUserInProgress(){
    return this._userInProgress;
  }

  void setUserInProgress(User user){
    this._userInProgress = user;
    notifyListeners();
  }

  Future<bool> signup(User user, Address address, BuildContext context) async {
    final addressResponse = await http.post(_rootUrl + "/address",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          "address": address.address,
          "address2": "",
          "district": address.district,
          "city_id": address.city_id,
          "postal_code": address.postal_code,
          "phone": address.phone
        }));
    print("POST Address response: ${addressResponse.statusCode}");
    if(addressResponse.statusCode != 200){
      return false;
    }

    String body = utf8.decode(addressResponse.bodyBytes);
    final jsonData = jsonDecode(body);
    int address_id = jsonData[0]['address_id'];
    // print(jsonData);
    final userResponse = await http.post(_rootUrl + "/user",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json;',
        },
        body: jsonEncode(<String, dynamic>{
          "store_id": this._currentStore.store_id,
          "first_name": user.first_name,
          "last_name": user.last_name,
          "email": user.email,
          "address_id": address_id,
        }));
    print("POST User response: ${userResponse.statusCode}");
    if(userResponse.statusCode != 200){
      return false;
    }
    final newBody = utf8.decode(userResponse.bodyBytes);
    final newJsonData = jsonDecode(newBody);
    //print("Datos llegados: $newJsonData");
    //print("UserId: ${newJsonData[0]['user_id']}");
    this._currentUser.user_id = newJsonData[0]['user_id'];
    this._currentUser.store_id = newJsonData[0]['store_id'];
    this._currentUser.first_name = newJsonData[0]['first_name'];
    this._currentUser.last_name = newJsonData[0]['last_name'];
    this._currentUser.email = newJsonData[0]['email'];
    this._currentUser.address_id = newJsonData[0]['address_id'];

    await _storage.write(key: 'user_id', value: newJsonData[0]['user_id'].toString());
    this._loggedIn = true;
    print("Redirecting...");
    if(this._previous == "home")
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => HomePage()), (route) => false);
    else if(this._previous == "payment")
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => MakePayment()), (route) => false);
    return true;
  }

  Future<bool> updateAddress(Address address, BuildContext context) async {
    final addressResponse = await http.post(_rootUrl + "/address",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          "address": address.address,
          "address2": "",
          "district": address.district,
          "city_id": address.city_id,
          "postal_code": address.postal_code,
          "phone": address.phone
        }));
    print("POST Address response: ${addressResponse.statusCode}");
    if(addressResponse.statusCode != 200){
      return false;
    }

    String body = utf8.decode(addressResponse.bodyBytes);
    final jsonData = jsonDecode(body);
    int address_id = jsonData[0]['address_id'];
    // print(jsonData);
    final userResponse = await http.put(_rootUrl + "/user/${this._currentUser.user_id}",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          "first_name": this._currentUser.first_name,
          "last_name": this._currentUser.last_name,
          "email": this._currentUser.email,
          "address_id": address_id,
        }));
    print("PUT User response: ${userResponse.statusCode}");
    if(userResponse.statusCode != 200){
      return false;
    }
    this._currentUser.address_id = address_id;
    this._loggedIn = true;
    print("Redirecting...");
    if(this._previous == "home")
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => HomePage()), (route) => false);
    else if(this._previous == "payment")
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => MakePayment()), (route) => false);
    return true;
  }

  Future<bool> login(User user, BuildContext context) async{
    final response = await http.post(_rootUrl + '/user/login',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json;',
        },
        body: jsonEncode(<String, String>{
          "email": user.email,
        }));
    print("Login response: ${response.statusCode}");

    if(response.statusCode != 200){
      return false;
    }
    else {
      // Save in secure storage
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      print(jsonData[0]['user_id']);
      this._currentUser.user_id = jsonData[0]['user_id'];
      this._currentUser.store_id = jsonData[0]['store_id'];
      this._currentUser.first_name = jsonData[0]['first_name'];
      this._currentUser.last_name = jsonData[0]['last_name'];
      this._currentUser.email = jsonData[0]['email'];
      this._currentUser.address_id = jsonData[0]['address_id'];

      await _storage.write(key: 'user_id', value: jsonData[0]['user_id'].toString());
      this._loggedIn = true;
      if(this._previous == "home")
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => HomePage()), (route) => false);
      else if(this._previous == "payment")
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => MakePayment()), (route) => false);
      return true;
    }

    /*
    // ABM
    // Read value
    String value = await storage.read(key: 'token');

    // Read all values
    Map<String, String> allValues = await storage.readAll();

    // Delete value
    await storage.delete(key: key);

    // Delete all
    await storage.deleteAll();
     */

  }

  Future<Address> getAddress() async{
    Address address;
    final response = await http.get(_rootUrl + "/address/${this._currentUser.address_id}");
    print('GET Address status code:' + response.statusCode.toString());
    if(response.statusCode == 200){
      String body = utf8.decode(response.bodyBytes);
      final jsonData = json.decode(body);
      //print('All movies: ' + response.body);
      //print("First data: " + jsonData[0]['title']);
      address = new Address();
      address.address_id = jsonData[0]['address_id'];
      address.address = jsonData[0]['address'];
      address.district = jsonData[0]['district'];
      address.city = jsonData[0]['city'];
      address.postal_code = jsonData[0]['postal_code'];
      address.phone = jsonData[0]['phone'];
    }
    return address;
  }

  Future<List<Film>> getFilms(int storeId) async {
    List<Film> films = [];
    final response = await http.get(_rootUrl + "/film/${this._currentStore.store_id}");
    print('GET Film Status code:' + response.statusCode.toString());
    if(response.statusCode == 200){
      String body = utf8.decode(response.bodyBytes);
      final jsonData = json.decode(body);
      //print('All movies: ' + response.body);
      //print("First data: " + jsonData[0]['title']);
      int limit = 0;
      for (var item in jsonData) {
        if(limit == 50)
          break;
        Film currentFilm = Film();
        currentFilm.film_id = item['film_id'];
        currentFilm.title = item['title'];
        currentFilm.description = item['description'];
        currentFilm.release_year = item['release_year'];
        currentFilm.language = item['language'];
        currentFilm.original_language = item['original_language'];
        currentFilm.rental_rate = item['rental_rate'];
        currentFilm.length = item['length'];
        currentFilm.replacement_cost = item['replacement_cost'];
        currentFilm.rating = item['rating'];
        currentFilm.special_features = item['special_features'];
        currentFilm.quantity = item['quantity'];
        currentFilm.selected = false;
        films.add(currentFilm);
        limit++;
      }
      //print("List: $films");
      this._allFilms = films;
    }
    return films;
  }

  Future<Map<String, dynamic>> findFilms(String query) async {
    List<Film> films = [];
    Map<String, dynamic> result = {};

    // Process query
    query = query.toUpperCase();
    List<String> queryWords = query.split("&");

    // Validate parameters
    Map<String, String> globalParameters = {};
    print("viendo parametros de busqueda");
    for(String s in queryWords){
      print("Iteracion con $s");
      List<String> parameter = s.split("=");
      if(parameter[0] == "TITLE" || parameter[0] == "ACTOR"){
        print("se encontro parametro valido");
        globalParameters[parameter[0]] = parameter[1];
      }
      else{
        print("parametros mal hechos, NULL");
        result["error"] = true;
        result["data"] = films;
        return result;
      }
    }

    // Process Search
    if(globalParameters.length == 1){
      if(globalParameters.containsKey("TITLE")){
        print("buscando por titulo");
        // Search by title
        final response = await http.get(_rootUrl + "/film/${this._currentStore.store_id}?title=${globalParameters['TITLE']}");
        print('GET Film Title Search Status code:' + response.statusCode.toString());
        if(response.statusCode == 200){
          String body = utf8.decode(response.bodyBytes);
          final jsonData = json.decode(body);
          //print('All movies: ' + response.body);
          //print("First data: " + jsonData[0]['title']);
          for (var item in jsonData) {
            Film currentFilm = Film();
            currentFilm.film_id = item['film_id'];
            currentFilm.title = item['title'];
            currentFilm.description = item['description'];
            currentFilm.release_year = item['release_year'];
            currentFilm.language = item['language'];
            currentFilm.original_language = item['original_language'];
            currentFilm.rental_rate = item['rental_rate'];
            currentFilm.length = item['length'];
            currentFilm.replacement_cost = item['replacement_cost'];
            currentFilm.rating = item['rating'];
            currentFilm.special_features = item['special_features'];
            currentFilm.quantity = item['quantity'];
            currentFilm.selected = false;
            films.add(currentFilm);
          }
          //print("List: $films");
          result["error"] = false;
          result["data"] = films;
          return result;
        }
      }
      else{
        print("buscando por actor");
        // Search by Actor
        final response = await http.get(_rootUrl + "/film/${this._currentStore.store_id}?actor=${globalParameters['ACTOR']}");
        print('GET Film Actor Search Status code:' + response.statusCode.toString());
        if(response.statusCode == 200){
          String body = utf8.decode(response.bodyBytes);
          final jsonData = json.decode(body);
          //print('All movies: ' + response.body);
          //print("First data: " + jsonData[0]['title']);
          for (var item in jsonData) {
            Film currentFilm = Film();
            currentFilm.film_id = item['film_id'];
            currentFilm.title = item['title'];
            currentFilm.description = item['description'];
            currentFilm.release_year = item['release_year'];
            currentFilm.language = item['language'];
            currentFilm.original_language = item['original_language'];
            currentFilm.rental_rate = item['rental_rate'];
            currentFilm.length = item['length'];
            currentFilm.replacement_cost = item['replacement_cost'];
            currentFilm.rating = item['rating'];
            currentFilm.special_features = item['special_features'];
            currentFilm.quantity = item['quantity'];
            currentFilm.selected = false;
            films.add(currentFilm);
          }
          //print("List: $films");
          result["error"] = false;
          result["data"] = films;
          return result;
        }
      }
    }
    else{
      print("buscando por titulo y actor");
      // Search both
      final response = await http.get(_rootUrl + "/film/${this._currentStore.store_id}?title=${globalParameters['TITLE']}&actor=${globalParameters['ACTOR']}");
      print('GET Film Title & Actor Search Status code:' + response.statusCode.toString());
      if(response.statusCode == 200){
        String body = utf8.decode(response.bodyBytes);
        final jsonData = json.decode(body);
        //print('All movies: ' + response.body);
        //print("First data: " + jsonData[0]['title']);
        for (var item in jsonData) {
          Film currentFilm = Film();
          currentFilm.film_id = item['film_id'];
          currentFilm.title = item['title'];
          currentFilm.description = item['description'];
          currentFilm.release_year = item['release_year'];
          currentFilm.language = item['language'];
          currentFilm.original_language = item['original_language'];
          currentFilm.rental_rate = item['rental_rate'];
          currentFilm.length = item['length'];
          currentFilm.replacement_cost = item['replacement_cost'];
          currentFilm.rating = item['rating'];
          currentFilm.special_features = item['special_features'];
          currentFilm.quantity = item['quantity'];
          currentFilm.selected = false;
          films.add(currentFilm);
        }
        //print("List: $films");
        result["error"] = false;
        result["data"] = films;
        return result;
      }
    }
    print("No entro en ninguno... generando randoms");
    final response = await http.get(_rootUrl + "/film/random/${this._currentStore.store_id}");
    print('GET Random Film Status code:' + response.statusCode.toString());
    if(response.statusCode == 200){
      String body = utf8.decode(response.bodyBytes);
      final jsonData = json.decode(body);
      //print('All movies: ' + response.body);
      //print("First data: " + jsonData[0]['title']);
      for (var item in jsonData) {
        Film currentFilm = Film();
        currentFilm.film_id = item['film_id'];
        currentFilm.title = item['title'];
        currentFilm.description = item['description'];
        currentFilm.release_year = item['release_year'];
        currentFilm.language = item['language'];
        currentFilm.original_language = item['original_language'];
        currentFilm.rental_rate = item['rental_rate'];
        currentFilm.length = item['length'];
        currentFilm.replacement_cost = item['replacement_cost'];
        currentFilm.rating = item['rating'];
        currentFilm.special_features = item['special_features'];
        currentFilm.quantity = item['quantity'];
        currentFilm.selected = false;
        films.add(currentFilm);
      }
    }
    result["error"] = true;
    result["data"] = films;
    return result;
  }

  Future<List<Film>> getRandomMovies() async{
    List<Film> films = [];
    final response = await http.get(_rootUrl + "/film/${this._currentStore.store_id}");
    print('GET Film Status code:' + response.statusCode.toString());
    if(response.statusCode == 200){
      String body = utf8.decode(response.bodyBytes);
      final jsonData = json.decode(body);
      //print('All movies: ' + response.body);
      //print("First data: " + jsonData[0]['title']);
      int limit = 0;
      for (var item in jsonData) {
        if(limit == 50)
          break;
        Film currentFilm = Film();
        currentFilm.film_id = item['film_id'];
        currentFilm.title = item['title'];
        currentFilm.description = item['description'];
        currentFilm.release_year = item['release_year'];
        currentFilm.language = item['language'];
        currentFilm.original_language = item['original_language'];
        currentFilm.rental_rate = item['rental_rate'];
        currentFilm.length = item['length'];
        currentFilm.replacement_cost = item['replacement_cost'];
        currentFilm.rating = item['rating'];
        currentFilm.special_features = item['special_features'];
        currentFilm.quantity = item['quantity'];
        currentFilm.selected = false;
        films.add(currentFilm);
        limit++;
      }
      //print("List: $films");
      this._allFilms = films;
    }
    return films;
  }

  void setAllFilms(List<Film> films){
    this._allFilms = films;
    notifyListeners();
  }

  List<Film> getAllFilms(){
    return this._allFilms;
  }

  List<Film> getCart(){
    return this._cart;
  }

  void addToCart(Film film){
    this._cart.add(film);
    print("Added to cart");
    notifyListeners();
  }

  void deleteFromCart(int id){
    int index = -1;
    for(int i = 0; i<this._cart.length; i++){
      if(this._cart[i].film_id == id){
        index = i;
        break;
      }
    }
    if(index != -1) {
      this._cart.removeAt(index);
      print("Removed from cart");
    }
    notifyListeners();
  }

  String getPrevious(){
    return this._previous;
  }

  void setPrevious(String previous){
    this._previous = previous;
  }

  bool getLoggedState(){
    print("estamos checando si esta loggeado...");
    return this._loggedIn;
  }

  void setLoggedState(bool logged){
    this._loggedIn = logged;
    notifyListeners();
  }

  User getCurrentUser(){
    return this._currentUser;
  }

  void logout() async {
    await _storage.delete(key: 'country_id');
    await _storage.delete(key: 'store_id');
    await _storage.delete(key: 'user_id');
    this._currentUser = User();
    this._currentStore = Store();
    setLoggedState(false);
    notifyListeners();
  }

  void setPrices(double original, double discount, double total, DateTime returnDate){
    this._original = original;
    this._discount = discount;
    this._total = total;
    this._returnDate = returnDate;
    notifyListeners();
  }

  double getOriginal(){
    return this._original;
  }

  double getDiscount(){
    return this._discount;
  }

  double getTotal(){
    return this._total;
  }

  void rentMovies(BuildContext context) async {
    // Get Inventory IDs.
    List<int> inventories = [];
    for(var film in this._cart){
      final response = await http.post(_rootUrl + "/rent/inventory",
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Accept': 'application/json;',
          },
          body: jsonEncode(<String, dynamic>{
            "film_id": film.film_id,
            "store_id": this._currentStore.store_id,
            "return_date": DateTime.now().toString(),
          }));

      print("Inventory X status code: ${response.statusCode}");
      if(response.statusCode != 200){
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => PaymentResponse(title: "Oops!", response: "An unexpected error has occurred. Please contact for support",)), (route) => false);
      }
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      //print(jsonData);
      int id = jsonData[0]['inventory_id'];
      inventories.add(id);
    }

    // Rent all films
    List<int> rentals = [];
    for(int i = 0; i<inventories.length; i++){
      final response = await http.post(_rootUrl + "/rent",
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Accept': 'application/json;',
          },
          body: jsonEncode(<String, dynamic>{
            "rental_date": DateTime.now().toString(),
            "inventory_id": inventories[i],
            "customer_id": this._currentUser.user_id,
            "return_date": this._returnDate.toString(),
          }));

      print("Rental X status code: ${response.statusCode}");
      if(response.statusCode != 200){
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => PaymentResponse(title: "Oops!", response: "An unexpected error has occurred. Please contact for support",)), (route) => false);
      }
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      //print(jsonData);
      int id = jsonData[0]['rental_id'];
      rentals.add(id);
    }

    // Pay all films
    for(int i = 0; i<rentals.length; i++){
      final response = await http.post(_rootUrl + "/payment",
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Accept': 'application/json;',
          },
          body: jsonEncode(<String, dynamic>{
            "customer_id": this._currentUser.user_id,
            "rental_id": rentals[i],
            "amount": this._total / 3,
            "payment_date": DateTime.now().toString(),
          }));

      print("Payment X status code: ${response.statusCode}");
      if(response.statusCode != 200){
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => PaymentResponse(title: "Oops!", response: "An unexpected error has occurred. Please contact for support",)), (route) => false);
      }
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      //print(jsonData);
    }
    this._cart.clear();
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => PaymentResponse(title: "Done!", response: "Your payment's been registered successfully!",)), (route) => false);
  }


/*
  // Manage tasks
  Future<Task> getTaskAt(int id, BuildContext context) async {
    String token = await _storage.read(key: 'token');
    final response = await http.get(_url + '/$id',
        headers: <String, String>{
          'Authorization': token
        });

    print('Response Code:' + response.statusCode.toString());
    if(response.statusCode != 200){
      await _storage.delete(key: 'token');
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => LoginForm()), (route) => false);
    }
    else {
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      print('Task $id:' + response.body);
      print(jsonData[0]['title']);
      return Task(jsonData[0]['task_id'], jsonData[0]['title'], jsonData[0]['detail'],
          jsonData[0]['detail'], (jsonData[0]['task_status'] == 'pending' ? true : false));
    }
  }

  void addTask(Task task, BuildContext context) async {
    String token = await _storage.read(key: 'token');
    final response = await http.post(_url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': token
        },
        body: jsonEncode(<String, String>{
          "title": task.title,
          "detail": task.description
        }));
    print('Add task response: ' + response.body);
    if(response.statusCode != 200){
      await _storage.delete(key: 'token');
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => LoginForm()), (route) => false);
    }
    notifyListeners();
  }

  void editTask(Task task, BuildContext context) async {
    String token = await _storage.read(key: 'token');
    final response = await http.put(_url + '/${task.id}',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': token
        },
        body: jsonEncode(<String, String>{
          "title": task.title,
          "detail": task.description
        }));
    print('Edit task response: ' + response.body);
    if(response.statusCode != 200){
      await _storage.delete(key: 'token');
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => LoginForm()), (route) => false);
    }
    notifyListeners();
  }

  void editStatus(int id, bool state, BuildContext context) async {
    String status = (state) ? 'pending' : 'completed';
    String token = await _storage.read(key: 'token');
    final response = await http.put(_url + '/$id?state=' + status,
        headers: <String, String>{
          'Authorization': token
        });
    print('Edit task status response: ' + response.body);
    if(response.statusCode != 200){
      await _storage.delete(key: 'token');
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => LoginForm()), (route) => false);
    }
    notifyListeners();
  }

  void deleteTask(int id, BuildContext context) async {
    String token = await _storage.read(key: 'token');
    final response = await http.delete(_url + '/$id',
        headers: <String, String>{
          'Authorization': token
        });
    print('Delete task response: ' + response.body);
    if(response.statusCode != 200){
      await _storage.delete(key: 'token');
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => LoginForm()), (route) => false);
    }
    notifyListeners();
  }

  // Manage users
  dynamic getStorage(){
    return this._storage;
  }

  Future<bool> login(User user, BuildContext context) async {
    final response = await http.post(_rootUrl + 'auth',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "username": user.username,
          "password": user.pass
        }));
    print('Login response: ' + response.headers.toString());

    if(response.statusCode == 401){
      return false;
    }
    else {
      // Save in secure storage
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      print(jsonData['token']);
      await _storage.write(key: 'token', value: jsonData['token']);
      this._username = jsonData['name'];
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => HomePage()), (route) => false);
      return true;
    }

    /*
    // ABM
    // Read value
    String value = await storage.read(key: 'token');

    // Read all values
    Map<String, String> allValues = await storage.readAll();

    // Delete value
    await storage.delete(key: key);

    // Delete all
    await storage.deleteAll();
     */
  }

  Future<bool> signup(User user, BuildContext context) async {
    final response = await http.post(_rootUrl + 'user',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "username": user.username,
          "password": user.pass
        }));
    print('Login response: ' + response.headers.toString());

    if(response.statusCode != 200){
      return false;
    }
    else {
      // Save in secure storage
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      print(jsonData['token']);
      await _storage.write(key: 'token', value: jsonData['token']);
      this._username = jsonData['name'];
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => HomePage()), (route) => false);
      return true;
    }
  }

  void logout() async {
    await _storage.delete(key: 'token');
    _username = null;
    notifyListeners();
  }

   */
}