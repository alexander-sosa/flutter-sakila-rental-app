import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sakila_app/views/HomePage.dart';

class PaymentResponse extends StatefulWidget {
  const PaymentResponse({Key key, this.title, this.response}) : super(key: key);

  final String title;
  final String response;

  @override
  _PaymentResponseState createState() => _PaymentResponseState();
}

class _PaymentResponseState extends State<PaymentResponse> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: message(),
    );
  }

  int randomNumber(){
    var rnd = new Random();
    return rnd.nextInt(500);
  }

  Widget message(){
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  Spacer(),
                  Text(widget.title, style: TextStyle(fontSize: 32, color: Colors.pink, fontWeight: FontWeight.bold),),
                  Text(widget.response),
                  Spacer(flex: 2,),
                  Image.network("https://picsum.photos/id/${randomNumber()}/300")
                ],
              )
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 45),
                child: Column(
                  children: [
                    SizedBox(height: 60,),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: FlatButton(
                        onPressed: (){
                          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => HomePage()), (route) => false);
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)
                        ),
                        color: Colors.pink,
                        child: Text("Back to home", style: TextStyle(color: Colors.white),)
                      ),
                    )
                  ],
                ),
              )
            )
          ],
        ),
      ),
    );
  }

  Widget initialMessage(){
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(60.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.response, style: TextStyle(fontSize: 32,), textAlign: TextAlign.center,),
            SizedBox(height: 30,),
            ElevatedButton(
                onPressed: (){

                },
                child: Container(
                  color: Colors.pink,
                  height: 50,
                  child: Center(
                      child: Text("Go back to Home")
                  ),
                )
            ),
          ],
        ),
      ),
    );
  }

}
