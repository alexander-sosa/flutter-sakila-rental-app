import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sakila_app/dto/Address.dart';
import 'package:sakila_app/servers/sakila-provider.dart';
import 'package:sakila_app/views/HomePage.dart';
import 'package:sakila_app/views/address.dart';
import 'package:sakila_app/views/update-address.dart';

class MakePayment extends StatefulWidget {
  const MakePayment({Key key}) : super(key: key);

  @override
  _MakePaymentState createState() => _MakePaymentState();
}

class _MakePaymentState extends State<MakePayment> {
  Future<Address> address;

  @override
  Widget build(BuildContext context) {
    // init data
    address = Provider.of<SakilaProvider>(context, listen: false).getAddress();

    return Scaffold(
      appBar: AppBar(
        title: Text("Confirm purchase"),
      ),
      body: FutureBuilder(
        future: address,
        builder: (context, snapshot){
          if(snapshot.hasData){
            return data(snapshot.data);
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      //data(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          setState(() {
            print("Making payment");
            Provider.of<SakilaProvider>(context, listen: false).rentMovies(context);
          });
        },
        tooltip: 'Confirm purchase',
        child: Icon(Icons.attach_money),
      ),
    );
  }

  Widget data(Address address){
    double original = Provider.of<SakilaProvider>(context, listen: false).getOriginal();
    double discount = Provider.of<SakilaProvider>(context, listen: false).getDiscount();
    double total = Provider.of<SakilaProvider>(context, listen: false).getTotal();

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Delivery Address ", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 32,),),
          SizedBox(height: 30,),
          Text("Address: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),),
          SizedBox(height: 5,),
          Text(address.address, style: TextStyle(fontSize: 15),),
          SizedBox(height: 20,),
          Text("District: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),),
          SizedBox(height: 5,),
          Text(address.district, style: TextStyle(fontSize: 15),),
          SizedBox(height: 20,),
          Text("City: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),),
          SizedBox(height: 5,),
          Text(address.city, style: TextStyle(fontSize: 15),),
          SizedBox(height: 5,),
          Container(
            child: FlatButton(
              onPressed: (){
                Provider.of<SakilaProvider>(context, listen: false).setPrevious("payment");
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => UpdateAddress()), (route) => false);
              },
              child: Text('Change address...', style: TextStyle(color: Colors.blueAccent, decoration: TextDecoration.underline),),
            ),
          ),
          SizedBox(height: 20,),

          Text("Payment Info ", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 32,),),
          SizedBox(height: 30,),
          Text("Original price: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),),
          SizedBox(height: 5,),
          Text(original.toStringAsFixed(2) + " USD", style: TextStyle(fontSize: 15),),
          SizedBox(height: 20,),
          Text("Discount: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),),
          SizedBox(height: 5,),
          Text(discount.toStringAsFixed(2) + " USD", style: TextStyle(fontSize: 15),),
          SizedBox(height: 20,),
          Text("Total price: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),),
          SizedBox(height: 5,),
          Text(total.toStringAsFixed(2) + " USD", style: TextStyle(fontSize: 15),),
          SizedBox(height: 5,),
          Container(
            child: FlatButton(
              onPressed: (){
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => HomePage()), (route) => false);
              },
              child: Text('CANCEL TRANSACTION', style: TextStyle(color: Colors.pink, decoration: TextDecoration.underline),),
            ),
          ),
          SizedBox(height: 20,),
        ],
      ),
    );
  }
}
