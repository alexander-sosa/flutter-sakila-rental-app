import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sakila_app/dto/Address.dart';
import 'package:sakila_app/servers/sakila-provider.dart';
import 'package:sakila_app/views/HomePage.dart';
import 'package:sakila_app/views/payment.dart';

class UpdateAddress extends StatefulWidget {
  const UpdateAddress({Key key}) : super(key: key);

  @override
  _UpdateAddressState createState() => _UpdateAddressState();
}

class _UpdateAddressState extends State<UpdateAddress> {
  String _error1, _error2, _error3, _error4;
  Future<bool> _reject;
  bool _errorCity = false;

  Future<Map<int, String>> cities;
  Future<Address> address;
  List<DropdownMenuItem<int>> listDrop = [];
  int _selected;

  int gotten = 0;

  TextEditingController _addressCtrl = TextEditingController();
  TextEditingController _districtCtrl = TextEditingController();
  TextEditingController _postalCodeCtrl = TextEditingController();
  TextEditingController _phoneCtrl = TextEditingController();
  var _addressFormKey = GlobalKey<FormState>();
  var _districtFormKey = GlobalKey<FormState>();
  var _postalCodeFormKey = GlobalKey<FormState>();
  var _phoneFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // init data
    cities = Provider.of<SakilaProvider>(context, listen: true).getCities();
    if(gotten < 2) {
      address = Provider.of<SakilaProvider>(context, listen: true).getAddress();
      gotten++;
    }
    return Scaffold(
      body: FutureBuilder(
        future: address,
        builder: (context, snapshot){
          if(snapshot.hasData){
            return formBuilder(snapshot.data);
          }
          else{
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget formBuilder(Address address){
    if(gotten < 2) {
      _addressCtrl.text = address.address;
      _districtCtrl.text = address.district;
      _postalCodeCtrl.text = address.postal_code;
      _phoneCtrl.text = address.phone;
    }
    return FutureBuilder(
        future: cities,
        builder: (context, snapshot){
          if(snapshot.hasData){
            return allForm(snapshot.data);
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        }
    );
  }

  Widget allForm(Map<int, String> allCities){
    loadCities(allCities);
    return SingleChildScrollView(
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height,
          maxWidth: MediaQuery.of(context).size.width,
        ),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.pink[700], Colors.pink[500]],
                begin: Alignment.topLeft,
                end: Alignment.centerRight
            )
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 45.0, horizontal: 50.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Update your address', style: TextStyle(
                        color: Colors.white,
                        fontSize: 42.0,
                        fontWeight: FontWeight.w800,
                      )),
                    ],
                  ),
                )
            ),
            Expanded(
              flex: 5,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50)
                    )
                ),
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        FutureBuilder(
                          future: _reject,
                          builder: (context, snapshot){
                            if(snapshot.hasData){
                              bool msg = snapshot.data;
                              if(msg == false){
                                return Column(
                                  children: [
                                    Text('Something went wrong... try again', style: TextStyle(color: Colors.red),),
                                    SizedBox(height: 30,)
                                  ],
                                );
                              }
                              else{
                                return SizedBox(height: 0,);
                              }
                            }
                            return SizedBox(height: 0,);
                          },
                        ),
                        DropdownButton(
                            value: _selected,
                            items: listDrop,
                            icon: Icon(Icons.location_on, color: _errorCity ? Colors.pink : Colors.black,),
                            hint: Text("Select your city..."),
                            onChanged: (value) {
                              setState(() {
                                print("Selected: $value");
                                _errorCity = false;
                                _selected = value;
                              });
                            }
                        ),
                        SizedBox(height: 20.0,),
                        Form(
                          key: _districtFormKey,
                          child: TextField(
                            controller: _districtCtrl,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0),),
                              filled: true,
                              fillColor: Colors.grey[100],
                              labelText: "District",
                              suffixIcon: Icon(Icons.account_circle,),
                              errorText: _error2,
                            ),
                            keyboardType: TextInputType.text,
                          ),
                        ),
                        SizedBox(height: 20.0,),
                        Form(
                          key: _addressFormKey,
                          child: TextField(
                            controller: _addressCtrl,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0),),
                              filled: true,
                              fillColor: Colors.grey[100],
                              labelText: "Address",
                              suffixIcon: Icon(Icons.account_circle,),
                              errorText: _error1,
                            ),
                            keyboardType: TextInputType.text,
                          ),
                        ),
                        SizedBox(height: 20.0,),
                        Form(
                          key: _postalCodeFormKey,
                          child: TextField(
                            controller: _postalCodeCtrl,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0),),
                              filled: true,
                              fillColor: Colors.grey[100],
                              labelText: "Postal code",
                              suffixIcon: Icon(Icons.account_circle,),
                              errorText: _error3,
                            ),
                            keyboardType: TextInputType.text,
                          ),
                        ),
                        SizedBox(height: 20.0,),
                        Form(
                          key: _phoneFormKey,
                          child: TextField(
                            controller: _phoneCtrl,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0),),
                              filled: true,
                              fillColor: Colors.grey[100],
                              labelText: "Phone number",
                              suffixIcon: Icon(Icons.account_circle,),
                              errorText: _error4,
                            ),
                            keyboardType: TextInputType.text,
                          ),
                        ),
                        SizedBox(height: 20.0,),
                        Container(
                          width: double.infinity,
                          child: ElevatedButton(
                              onPressed: () {
                                Address currentAddress;
                                setState(() {
                                  if(_selected == null){
                                    _errorCity = true;
                                    return;
                                  }
                                  if(_districtCtrl.text.length == 0){
                                    _error2 = "Enter your district";
                                    return;
                                  }
                                  if(_addressCtrl.text.length == 0) {
                                    _error1 = "Enter your address";
                                    return;
                                  }
                                  if(_postalCodeCtrl.text.length == 0){
                                    _error3 = "Enter postal code";
                                    return;
                                  }
                                  if(_phoneCtrl.text.length == 0){
                                    _error4 = "Enter your phone number";
                                    return;
                                  }
                                  _error1 = _error2 = _error3 = _error4 = null;
                                  print("Todo nice");

                                  // Address
                                  currentAddress = new Address();
                                  currentAddress.address = _addressCtrl.text;
                                  currentAddress.city_id = _selected;
                                  currentAddress.district = _districtCtrl.text;
                                  currentAddress.postal_code = _postalCodeCtrl.text;
                                  currentAddress.phone = _phoneCtrl.text;
                                  _reject = Provider.of<SakilaProvider>(context, listen: false).updateAddress(
                                      currentAddress,
                                      context);
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 18.0),
                                child: Text('Update my address', style: TextStyle(color: Colors.white),),
                              )
                          ),
                        ),
                        SizedBox(height: 10.0,),
                        Container(
                          child: FlatButton(
                            onPressed: (){
                              String before = Provider.of<SakilaProvider>(context, listen: false).getPrevious();
                              if(before == "home")
                                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => HomePage()), (route) => false);
                              if(before == "payment")
                                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => MakePayment()), (route) => false);
                            },
                            child: Text('Cancel', style: TextStyle(color: Colors.red, decoration: TextDecoration.underline),),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
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
