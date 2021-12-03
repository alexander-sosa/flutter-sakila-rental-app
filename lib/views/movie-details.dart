import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sakila_app/dto/Film.dart';
import 'package:sakila_app/servers/sakila-provider.dart';

class MovieDetails extends StatefulWidget {
  const MovieDetails({Key key, this.film}) : super(key: key);

  final Film film;

  @override
  _MovieDetailsState createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {
  bool added;

  @override
  Widget build(BuildContext context) {
    added = inCart(widget.film.film_id);

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Movie Details"),
      ),
      backgroundColor: Colors.pink[200],
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: size.height,
              child: Stack(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: size.height * 0.3),
                    padding: EdgeInsets.only(
                      top: size.height * 0.12,
                      right: 30,
                      left: 30
                    ),
                    //height: 500,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(24),
                        topLeft: Radius.circular(24),
                      )
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RichText(
                                text: TextSpan(
                                    style: TextStyle(color: Colors.black54),
                                    children: [
                                      TextSpan(
                                          text: "Language\n"
                                      ),
                                      TextSpan(
                                          text: "${widget.film.language}",
                                          style: Theme.of(context).textTheme.headline5
                                      )
                                    ]
                                )
                            ),
                            RichText(
                                text: TextSpan(
                                    style: TextStyle(color: Colors.black54),
                                    children: [
                                      TextSpan(
                                          text: "Rating\n"
                                      ),
                                      TextSpan(
                                          text: "${widget.film.rating}",
                                          style: Theme.of(context).textTheme.headline5
                                      )
                                    ]
                                )
                            ),
                            RichText(
                                text: TextSpan(
                                    style: TextStyle(color: Colors.black54),
                                    children: [
                                      TextSpan(
                                          text: "Year\n"
                                      ),
                                      TextSpan(
                                          text: "${widget.film.release_year}",
                                          style: Theme.of(context).textTheme.headline5
                                      )
                                    ]
                                )
                            ),
                          ],
                        ),
                        SizedBox(height: 20,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RichText(
                                text: TextSpan(
                                    style: TextStyle(color: Colors.black54),
                                    children: [
                                      TextSpan(
                                          text: "Replacement Cost\n"
                                      ),
                                      TextSpan(
                                          text: "${widget.film.replacement_cost} USD",
                                          style: Theme.of(context).textTheme.headline5
                                      )
                                    ]
                                )
                            ),
                            RichText(
                                text: TextSpan(
                                    style: TextStyle(color: Colors.black54),
                                    children: [
                                      TextSpan(
                                          text: "Duration (min)    \n"
                                      ),
                                      TextSpan(
                                          text: "${widget.film.length}",
                                          style: Theme.of(context).textTheme.headline5
                                      )
                                    ]
                                )
                            ),
                            RichText(
                                text: TextSpan(
                                    style: TextStyle(color: Colors.black54),
                                    children: [
                                      TextSpan(
                                          text: "Stock      \n"
                                      ),
                                      TextSpan(
                                          text: "${widget.film.quantity}",
                                          style: Theme.of(context).textTheme.headline5
                                      )
                                    ]
                                )
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 30.0),
                          child: Text(widget.film.description, style: TextStyle(height: 1.5),),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("film", style: TextStyle(color: Colors.white),),
                        Text(widget.film.title, style: Theme.of(context).textTheme.headline4.copyWith(color: Colors.white, fontWeight: FontWeight.bold),),
                        SizedBox(height: 15,),
                        Row(
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(text: "Rent Price\n"),
                                  TextSpan(
                                    text: "\$${widget.film.rental_rate}/day",
                                    style: Theme.of(context).textTheme.headline5.copyWith(color: Colors.white, fontWeight: FontWeight.bold)
                                  )
                                ]
                              )
                            ),
                            SizedBox(width: 25,),
                            Expanded(
                              child: Image.network("https://picsum.photos/id/${widget.film.film_id}/200/170")
                            )
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          setState(() {
            if(!inCart(widget.film.film_id)) {
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              Provider.of<SakilaProvider>(context, listen: false).addToCart(widget.film);
            }
            else{
              ScaffoldMessenger.of(context).showSnackBar(snackBar2);
              Provider.of<SakilaProvider>(context, listen: false).deleteFromCart(widget.film.film_id);
            }
          });
        },
        tooltip: 'Add shopping cart',
        child: Icon(inCart(widget.film.film_id) ? Icons.clear : Icons.add),
      ),
    );
  }

  final snackBar = SnackBar(content: Text('Added to shopping cart', style: TextStyle(color: Colors.white),), backgroundColor: Colors.pink,);
  final snackBar2 = SnackBar(content: Text('Deleted from shopping cart', style: TextStyle(color: Colors.white),), backgroundColor: Colors.pink,);

  bool inCart(int filmId){
    List<Film> cart = Provider.of<SakilaProvider>(context, listen: false).getCart();
    for(var film in cart){
      if(film.film_id == filmId)
        return true;
    }
    return false;
  }
}
