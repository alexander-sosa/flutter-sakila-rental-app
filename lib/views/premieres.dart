import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sakila_app/dto/Film.dart';
import 'package:sakila_app/servers/sakila-provider.dart';
import 'package:sakila_app/views/select-country.dart';

import 'HomePage.dart';
import 'cart.dart';
import 'login-signup.dart';
import 'most-rented-weekly.dart';
import 'most-rented.dart';
import 'movie-details.dart';

class Premieres extends StatefulWidget {
  const Premieres({Key key}) : super(key: key);

  @override
  _PremieresState createState() => _PremieresState();
}

class _PremieresState extends State<Premieres> {
  int position = 0;
  Future<List<Film>> films;
  Size size;

  @override
  Widget build(BuildContext context) {
    // init data
    films = Provider.of<SakilaProvider>(context, listen: true).getPremieres(0);
    size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("Sakila Rental"),
        actions: [
          IconButton(
              icon: Icon(Icons.search),
              onPressed: (){
                showSearch(
                    context: context,
                    delegate: DataSearch()
                );
              }
          ),
          popup()
        ],
      ),
      body: FutureBuilder(
          future: films,
          builder: (context, snapshot){
            if(snapshot.hasData){
              if (snapshot.data.length == 0) {
                return Center(
                  child: Text("No movies in results"),
                );
              }
              return filmsGrid(snapshot.data);
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          setState(() {
            if(Provider.of<SakilaProvider>(context, listen: false).getCart().length > 0) {
              Route route = MaterialPageRoute(
                  builder: (context) => ShoppingCart());
              Navigator.of(context).push(route);
            }
            else{
              ScaffoldMessenger.of(context).showSnackBar(emptySnackBar);
            }
          });
        },
        tooltip: 'Go to shopping cart',
        child: Icon(Icons.shopping_cart),
      ),
    );
  }

  Widget popup(){
    if(Provider.of<SakilaProvider>(context, listen: false).getLoggedState()) {
      String username = Provider.of<SakilaProvider>(context, listen: false).getCurrentUser().first_name;
      return PopupMenuButton(
        itemBuilder: (ctx) =>
        [
          PopupMenuItem(child: Text('Hello ' + username), value: '0',),
          PopupMenuItem(child: Text('Go Home'), value: '4',),
          PopupMenuItem(child: Text('Premieres'), value: '5',),
          PopupMenuItem(child: Text('Top Rented'), value: '6',),
          PopupMenuItem(child: Text('Top Rented Week'), value: '7',),
          //PopupMenuItem(child: Text('Credits'), value: '1',),
          PopupMenuItem(child: Text('Logout'), value: '2',),
        ],
        onSelected: (value) {
          setState(() {
            switch (value) {
              case '0':
              // tasks = Provider.of<TaskServer>(context, listen: false).getTasks(context);
                break;
              case '1':
              // todo: create credits
              //Route route = MaterialPageRoute(builder: (context) => Credits());
              //Navigator.of(context).push(route);
                break;
              case '4':
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => HomePage()), (route) => false);
                break;
              case '5':
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => Premieres()), (route) => false);
                break;
              case '6':
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => MostRented()), (route) => false);
                break;
              case '7':
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => MostWeekly()), (route) => false);
                break;

              case '2':
                Provider.of<SakilaProvider>(context, listen: false).logout();
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => SelectCountry()), (route) => false);
                break;
              case '3':
                break;
            }
          });
        },
      );
    }
    else{
      return PopupMenuButton(
        itemBuilder: (ctx) =>
        [
          PopupMenuItem(child: Text('Login'), value: '0',),
          PopupMenuItem(child: Text('Go Home'), value: '4',),
          PopupMenuItem(child: Text('Premieres'), value: '5',),
          PopupMenuItem(child: Text('Top Rented'), value: '6',),
          PopupMenuItem(child: Text('Top Rented Week'), value: '7',),
          //PopupMenuItem(child: Text('Credits'), value: '1',),
        ],
        onSelected: (value) {
          setState(() {
            switch (value) {
              case '0':
                Provider.of<SakilaProvider>(context, listen: false).setPrevious("home");
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => LoginForm()), (route) => false);
                break;
              case '4':
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => HomePage()), (route) => false);
                break;
              case '5':
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => Premieres()), (route) => false);
                break;
              case '6':
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => MostRented()), (route) => false);
                break;
              case '7':
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => MostWeekly()), (route) => false);
                break;
              case '1':
              // todo: create Credits Page
                print("Credits in progress...");
                //tasks = Provider.of<TaskServer>(context, listen: false).getTasks(context);
                break;
            }
          });
        },
      );
    }
  }

  Widget filmsGrid(List<Film> films){
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Column(
        children: [
          Expanded(flex: 1, child: Text("Premieres", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28.0, color: Colors.pink), textAlign: TextAlign.left,)),
          Expanded(
            flex: 12,
            child: GridView.builder(
                itemCount: films.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 25.0,
                    crossAxisSpacing: 25.0,
                    childAspectRatio: 0.75
                ),
                itemBuilder: (context, index) => movies(films[index], films)
            ),
          ),
        ],
      ),
    );
  }

  Widget movies(Film film, List<Film> films){
    return Column(
      children: [
        GestureDetector(
          onTap: (){
            if(film.quantity < 1){
              null;
            }
            else {
              Route route = MaterialPageRoute(
                  builder: (context) => MovieDetails(film: film,));
              Navigator.of(context).push(route);
            }
          },
          onLongPress: (){
            if(film.quantity < 1){
              null;
            }
            else {
              setState(() {
                //print("esta tocandome! D:");
                if (inCart(film.film_id)) {
                  Provider.of<SakilaProvider>(context, listen: false)
                      .deleteFromCart(film.film_id);
                }
                else {
                  if (Provider
                      .of<SakilaProvider>(context, listen: false)
                      .getCart()
                      .length < 4)
                    Provider.of<SakilaProvider>(context, listen: false)
                        .addToCart(film);
                  else
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
                //print(film.selected);
              });
            }
          },
          child: Container(
            padding: EdgeInsets.all(5),
            height: 150,
            width: 150,
            decoration: BoxDecoration(
              color: film.quantity < 1 ? Colors.grey : Colors.pink[100],
            ),
            child: inCart(film.film_id) ?
            Center(child: Text("In Cart", style: TextStyle(fontWeight: FontWeight.bold),)) :
            (film.quantity < 1) ?
            ColorFiltered(
                colorFilter: ColorFilter.mode(
                    Colors.grey,
                    BlendMode.saturation
                ),
                child: Image.network("https://picsum.photos/id/${film.film_id}/135")
            )
                : Image.network("https://picsum.photos/id/${film.film_id}/135", ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(film.title, style: TextStyle(), overflow: TextOverflow.ellipsis, maxLines: 1,),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("\$0.99 ", style: TextStyle(fontWeight: FontWeight.bold),),
            Text(" In stock: ${film.quantity}", style: TextStyle(color: Colors.pink),),
          ],
        ),
      ],
    );
  }

  bool inCart(int filmId){
    List<Film> cart = Provider.of<SakilaProvider>(context, listen: false).getCart();
    for(var film in cart){
      if(film.film_id == filmId)
        return true;
    }
    return false;
  }

  final snackBar = SnackBar(content: Text('Only 4 max movies allowed', style: TextStyle(color: Colors.white),), backgroundColor: Colors.pink,);
  final emptySnackBar = SnackBar(content: Text('Empty cart!', style: TextStyle(color: Colors.white),), backgroundColor: Colors.pink,);
}

class DataSearch extends SearchDelegate<String>{
  Future<Map<String, dynamic>> searchFilms;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: (){
            query = "";
          }
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: (){
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // init data
    searchFilms = Provider.of<SakilaProvider>(context, listen: true).findFilms(query);

    return Scaffold(
      body: FutureBuilder(
          future: searchFilms,
          builder: (context, snapshot){
            if(snapshot.hasData){
              Map<String, dynamic> result = snapshot.data;
              if(result['error'] && result['data'].length == 0)
                return Center(
                  child: Text("Bad parameters, try again"),
                );
              return filmsGrid(snapshot.data, context);
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          if(Provider.of<SakilaProvider>(context, listen: false).getCart().length > 0) {
            Route route = MaterialPageRoute(
                builder: (context) => ShoppingCart());
            Navigator.of(context).push(route);
          }
          else{
            ScaffoldMessenger.of(context).showSnackBar(emptySnackBar);
          }
        },
        tooltip: 'Go to shopping cart',
        child: Icon(Icons.shopping_cart),
      ),

    );
  }

  Widget filmsGrid(Map<String, dynamic> map, context){
    bool error = map['error'] as bool;
    List<Film> films = map['data'];
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Column(
        children: [
          Expanded(flex: 1, child: Text(error ? "Couldn't find results for search... You might like:" : "Search results", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.pink), textAlign: TextAlign.left,)),
          Expanded(
            flex: 12,
            child: GridView.builder(
                itemCount: films.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 25.0,
                    crossAxisSpacing: 25.0,
                    childAspectRatio: 0.75
                ),
                itemBuilder: (context, index) => movies(films[index], films, context)
            ),
          ),
        ],
      ),
    );
  }

  Widget movies(Film film, List<Film> films, context){
    return Column(
      children: [
        GestureDetector(
          onTap: (){
            Route route = MaterialPageRoute(builder: (context) => MovieDetails(film: film,));
            Navigator.of(context).push(route);
          },
          onLongPress: (){
            //print("esta tocandome! D:");
            if(inCart(film.film_id, context)){
              Provider.of<SakilaProvider>(context, listen: false).deleteFromCart(film.film_id);
            }
            else {
              if(Provider.of<SakilaProvider>(context, listen: false).getCart().length < 4)
                Provider.of<SakilaProvider>(context, listen: false).addToCart(film);
              else
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
            //print(film.selected);
          },
          child: Container(
            padding: EdgeInsets.all(5),
            height: 150,
            width: 150,
            decoration: BoxDecoration(
              color: Colors.pink[100],
            ),
            child: inCart(film.film_id, context) ? Center(child: Text("In Cart", style: TextStyle(fontWeight: FontWeight.bold),)) : Image.network("https://picsum.photos/id/${film.film_id}/135"),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(film.title, style: TextStyle(), overflow: TextOverflow.ellipsis, maxLines: 1,),
        ),
        Text("\$${film.rental_rate}", style: TextStyle(fontWeight: FontWeight.bold),),
      ],
    );
  }

  bool inCart(int filmId, context){
    List<Film> cart = Provider.of<SakilaProvider>(context, listen: false).getCart();
    for(var film in cart){
      if(film.film_id == filmId)
        return true;
    }
    return false;
  }

  final snackBar = SnackBar(content: Text('Only 4 max movies allowed', style: TextStyle(color: Colors.white),), backgroundColor: Colors.pink,);
  final emptySnackBar = SnackBar(content: Text('Empty cart!', style: TextStyle(color: Colors.white),), backgroundColor: Colors.pink,);

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty ? suggestions : suggestions.where((p) => p.startsWith(query)).toList();
    return ListView.builder(itemBuilder: (context, index) => ListTile(
      onTap: (){
        query = suggestions[index];
      },
      leading: Icon(Icons.movie),
      title: Text(suggestionList[index]),),
      itemCount: suggestionList.length,
    );
  }

  final suggestions = ["title=maude", "actor=gina", "title=window&actor=gina"];
}
