import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sakila_app/servers/sakila-provider.dart';
import 'package:sakila_app/views/HomePage.dart';

import '../main.dart';

class SelectCountry extends StatefulWidget {
  const SelectCountry({Key key}) : super(key: key);

  @override
  _SelectCountryState createState() => _SelectCountryState();
}

class _SelectCountryState extends State<SelectCountry> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome to Sakila!', style: TextStyle(
              color: Colors.black,
              fontSize: 40.0,
              fontWeight: FontWeight.w800,
            )),
            SizedBox(height: 10,),
            Text('Where are you buying from?', style: TextStyle(
                color: Colors.black,
                fontSize: 18.0,
                fontWeight: FontWeight.w300
            )),
            SizedBox(height: 70.0,),
            Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                color: Colors.pink,
                borderRadius: BorderRadius.circular(100.0)
              ),
              child: FlatButton(
                  onPressed: (){
                    setState(() {
                      print("Selected Australia");
                      Provider.of<SakilaProvider>(context, listen: false).selectCountry(8, "Australia", 2);
                      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => HomePage()), (route) => false);
                    });
                  },
                  child: Text("Australia", style: TextStyle(color: Colors.white, fontSize: 15),),
              ),
            ),
            SizedBox(height: 30.0,),
            Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                  color: Colors.pink[100],
                  borderRadius: BorderRadius.circular(100.0)
              ),
              child: FlatButton(
                onPressed: (){
                  setState(() {
                    print("Selected Canada");
                    Provider.of<SakilaProvider>(context, listen: false).selectCountry(20, "Canada", 1);
                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => HomePage()), (route) => false);
                  });
                },
                child: Text("Canada", style: TextStyle( fontSize: 15),),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
