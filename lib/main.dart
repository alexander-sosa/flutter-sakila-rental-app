import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sakila_app/dto/Film.dart';
import 'package:sakila_app/servers/sakila-provider.dart';
import 'package:sakila_app/views/HomePage.dart';
import 'package:sakila_app/views/address.dart';
import 'package:sakila_app/views/cart.dart';
import 'package:sakila_app/views/login-signup.dart';
import 'package:sakila_app/views/movie-details.dart';
import 'package:sakila_app/views/payment.dart';
import 'package:sakila_app/views/payments-response.dart';
import 'package:sakila_app/views/select-country.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider.value(value: SakilaProvider())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Sakila Rental',
        theme: ThemeData(
          primarySwatch: Colors.pink,
        ),
        //home: MyHomePage(title: 'Flutter Demo Home Page'),
        home: SelectCountry(),
      ),
    );
  }
  Film getFakeFilm(){
    Film currentFilm = Film();
    currentFilm.film_id = 1;
    currentFilm.title = "Fake film title";
    currentFilm.description = "lorem ipsum dolor sit amet lorem ipsum dolor sit amet lorem ipsum dolor sit amet lorem ipsum dolor sit amet lorem ipsum dolor sit amet lorem ipsum dolor sit amet lorem ipsum dolor sit amet lorem ipsum dolor sit amet lorem ipsum dolor sit amet lorem ipsum dolor sit amet";
    currentFilm.release_year = 2001;
    currentFilm.language = "English";
    currentFilm.original_language = "";
    currentFilm.rental_rate = 0.99;
    currentFilm.length = 59;
    currentFilm.replacement_cost = 26.3;
    currentFilm.rating = "PG-13";
    currentFilm.special_features = "Behind scenes,Behind scenes,Behind scenes,Behind scenes";
    currentFilm.quantity = 3;
    currentFilm.selected = false;
    return currentFilm;
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  Future<Map<int, String>> cities;
  List<DropdownMenuItem<int>> listDrop = [];
  int _selected;

  @override
  Widget build(BuildContext context) {
    // init data
    cities = Provider.of<SakilaProvider>(context, listen: true).getCities();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder(
        future: cities,
        builder: (context, snapshot){
          if(snapshot.hasData){
            return cityList(snapshot.data);
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Provider.of<SakilaProvider>(context, listen: false).getCities();
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget cityList(Map<int, String> allCities){
    loadCities(allCities);
    return DropdownButton(
      value: _selected,
      items: listDrop,
      hint: Text("Select your city..."),
      onChanged: (value) {
        setState(() {
          print("Selected: $value");
          _selected = value;
        });
      }
    );
  }

  void loadCities(Map<int, String> allCities){
    listDrop = [];
    allCities.forEach((key, value) {
      // print("key: $key, value: $value");
      listDrop.add(DropdownMenuItem(
          child: Text(value),
          value: key,
      ));
    });
  }
}
