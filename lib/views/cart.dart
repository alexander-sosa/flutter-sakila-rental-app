import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sakila_app/dto/Film.dart';
import 'package:sakila_app/servers/sakila-provider.dart';
import 'package:sakila_app/views/login-signup.dart';
import 'package:sakila_app/views/payment.dart';

class ShoppingCart extends StatefulWidget {
  const ShoppingCart({Key key}) : super(key: key);

  @override
  _ShoppingCartState createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  DateTime _returnDate;
  double _original, _discount, _total;
  List<Film> cart = [];

  @override
  Widget build(BuildContext context) {
    cart = Provider.of<SakilaProvider>(context, listen: true).getCart();
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Cart'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 10,),
              Text("Your Movies...", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
              SizedBox(height: 10,),
              Container(
                height: 300,
                child: cartGrid()
              ),
              SizedBox(height: 50,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
                    Text("Return date: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                    Text(_returnDate == null ? "  (select a date)" : "  " + _returnDate.toString(), style: TextStyle(fontSize: 15),),
                    IconButton(
                      icon: Icon(Icons.calendar_today, color: Colors.pink,),
                      onPressed: (){
                        showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(Duration(days: 7))
                        ).then((value) {
                          setState(() {
                            _returnDate = value;
                            setPrices();
                          });
                        });
                      }
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
                    Text("Original price: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                    Text(_returnDate == null ? "" : "  " + _original.toStringAsFixed(2) + " USD", style: TextStyle(fontSize: 15),),
                  ],
                ),
              ),
              SizedBox(height: 6,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
                    Text("Discount: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                    Text(_returnDate == null ? "" : "  " + _discount.toStringAsFixed(2) + " USD", style: TextStyle(fontSize: 15),),
                  ],
                ),
              ),
              SizedBox(height: 6,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
                    Text("Total price: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                    Text(_returnDate == null ? "" : "  " + _total.toStringAsFixed(2) + " USD", style: TextStyle(fontSize: 15,),),
                  ],
                ),
              ),
              SizedBox(height: 35,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: _returnDate == null ? null : () {
                        Provider.of<SakilaProvider>(context, listen: false).setPrices(_original, _discount, _total, _returnDate);
                        if(Provider.of<SakilaProvider>(context, listen: false).getLoggedState()){
                          Route route = MaterialPageRoute(builder: (context) => MakePayment());
                          Navigator.of(context).push(route);
                        }
                        else{
                          Provider.of<SakilaProvider>(context, listen: false).setPrevious("payment");
                          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => LoginForm()), (route) => false);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 18.0),
                        child: Text('Pay', style: TextStyle(color: Colors.white),),
                      )
                  ),
                ),
              ),

            ],
          ),
        ),
      )
    );
  }

  void setPrices(){
    int days = _returnDate.difference(DateTime.now()).inDays + 1;
    print("$days dias");
    print("${cart.length} peliculas");

    _original = 0.99 * days * cart.length;
    if(_original > 20){
      _discount = 0.2 * _original;
    }
    else if(_original > 15){
      _discount = 0.15 * _original;
    }
    else if(_original > 10){
      _discount = 0.1 * _original;
    }
    else{
      _discount = 0.0;
    }
    _total = _original - _discount;
  }

  Widget cartGrid(){
    return GridView.count(
      scrollDirection: Axis.vertical,
      crossAxisCount: 1,
      children: cartList(),
      childAspectRatio: 3,
    );
  }

  List<Widget> cartList(){
    List<Widget> cartWidgets = [];
    for(var film in cart){
      cartWidgets.add(
          Padding(
            padding: const EdgeInsets.only(left: 5, right: 5, top: 10),
            child: Card(
              elevation: 10,
              child: ListTile(
                title: Text(film.title, style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold, ), overflow: TextOverflow.ellipsis, maxLines: 1),
                subtitle: Text(film.description, style: TextStyle(fontSize: 16,), overflow: TextOverflow.ellipsis, maxLines: 2,),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.pink),
                  onPressed: (){
                    Provider.of<SakilaProvider>(context, listen: false).deleteFromCart(film.film_id);
                  },
                ),
                contentPadding: EdgeInsets.all(18),
              ),
            ),
          )
      );
    }
    return cartWidgets;
  }
}
