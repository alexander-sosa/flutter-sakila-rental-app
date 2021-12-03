import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sakila_app/dto/User.dart';
import 'package:sakila_app/servers/sakila-provider.dart';
import 'package:sakila_app/views/HomePage.dart';
import 'package:sakila_app/views/address.dart';
import 'package:sakila_app/views/cart.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  String _error1, _error2;
  bool _secureText = true;
  Future<bool> _reject;

  TextEditingController _userCtrl = TextEditingController();
  TextEditingController _passCtrl = TextEditingController();
  var _userFormKey = GlobalKey<FormState>();
  var _passFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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
                flex: 5,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(50),
                        bottomRight: Radius.circular(50),
                      )
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
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
                                    Text('Invalid credentials!', style: TextStyle(color: Colors.red),),
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
                        Form(
                          key: _userFormKey,
                          child: TextField(
                            controller: _userCtrl,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0),),
                              filled: true,
                              fillColor: Colors.grey[100],
                              labelText: "Email",
                              suffixIcon: Icon(Icons.account_circle,),
                              errorText: _error1,
                            ),
                            keyboardType: TextInputType.text,
                          ),
                        ),
                        SizedBox(height: 20.0,),
                        Form(
                          key: _passFormKey,
                          child: TextField(
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                filled: true,
                                fillColor: Colors.grey[100],
                                labelText: "Password",
                                suffixIcon: IconButton(
                                    icon: Icon(_secureText ? Icons.remove_red_eye : Icons.lock,),
                                    onPressed: (){
                                      setState(() {
                                        _secureText = !_secureText;
                                      });
                                    }
                                ),
                                errorText: _error2
                            ),
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: _secureText,
                            controller: _passCtrl,
                          ),
                        ),
                        SizedBox(height: 20.0,),
                        Container(
                          width: double.infinity,
                          child: ElevatedButton(
                              onPressed: () {
                                User currentUser;
                                setState(() {
                                  if(_userCtrl.text.length == 0) {
                                    _error1 = "Enter an email";
                                    return;
                                  }
                                  if(_passCtrl.text.length == 0){
                                    _error2 = "Enter a password";
                                    return;
                                  }
                                  _error1 = _error2 = null;
                                  print("Todo nice");
                                  //currentUser = new User(0, _userCtrl.text, _passCtrl.text);
                                  currentUser = new User();
                                  currentUser.email = _userCtrl.text;
                                  _reject = Provider.of<SakilaProvider>(context, listen: false).login(currentUser, context);
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 18.0),
                                child: Text('Login', style: TextStyle(color: Colors.white),),
                              )
                          ),
                        ),
                        SizedBox(height: 15.0,),
                        Container(
                          child: FlatButton(
                            onPressed: (){
                              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => SignupForm()), (route) => false);
                            },
                            child: Text('Not registered yet? Sign up!', style: TextStyle(color: Colors.blueAccent, decoration: TextDecoration.underline),),
                          ),
                        ),
                        Container(
                          child: FlatButton(
                            onPressed: (){
                              String before = Provider.of<SakilaProvider>(context, listen: false).getPrevious();
                              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => HomePage()), (route) => false);
                            },
                            child: Text('Cancel', style: TextStyle(color: Colors.red, decoration: TextDecoration.underline),),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 50.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Welcome back!', style: TextStyle(
                          color: Colors.white,
                          fontSize: 42.0,
                          fontWeight: FontWeight.w800,
                        )),
                        SizedBox(height: 10,),
                        Text("Login and continue renting movies.", style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w300
                        )),
                      ],
                    ),
                  )
              ),

            ],
          ),
        ),
      ),
    );
  }

}

class SignupForm extends StatefulWidget {
  const SignupForm({Key key}) : super(key: key);

  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  String _error1, _error2, _error3;
  bool _secureText = true;
  Future<bool> _reject;

  TextEditingController _firstNameCtrl = TextEditingController();
  TextEditingController _lastNameCtrl = TextEditingController();
  TextEditingController _emailCtrl = TextEditingController();
  var _firstNameKey = GlobalKey<FormState>();
  var _lastNameKey = GlobalKey<FormState>();
  var _emailKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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
                        Text('Hello!', style: TextStyle(
                          color: Colors.white,
                          fontSize: 42.0,
                          fontWeight: FontWeight.w800,
                        )),
                        SizedBox(height: 10,),
                        Text('Create an account and start renting movies.', style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w300
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
                                    Text('Invalid credentials, try again', style: TextStyle(color: Colors.red),),
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
                        Form(
                          key: _firstNameKey,
                          child: TextField(
                            controller: _firstNameCtrl,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0),),
                              filled: true,
                              fillColor: Colors.grey[100],
                              labelText: "First name",
                              suffixIcon: Icon(Icons.account_circle,),
                              errorText: _error1,
                            ),
                            keyboardType: TextInputType.text,
                          ),
                        ),
                        SizedBox(height: 20.0,),
                        Form(
                          key: _lastNameKey,
                          child: TextField(
                            controller: _lastNameCtrl,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0),),
                              filled: true,
                              fillColor: Colors.grey[100],
                              labelText: "Last name",
                              suffixIcon: Icon(Icons.account_circle,),
                              errorText: _error2,
                            ),
                            keyboardType: TextInputType.text,
                          ),
                        ),
                        SizedBox(height: 20.0,),
                        Form(
                          key: _emailKey,
                          child: TextField(
                            controller: _emailCtrl,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0),),
                              filled: true,
                              fillColor: Colors.grey[100],
                              labelText: "Email",
                              suffixIcon: Icon(Icons.account_circle,),
                              errorText: _error3,
                            ),
                            keyboardType: TextInputType.text,
                          ),
                        ),
                        SizedBox(height: 20.0,),
                        Container(
                          width: double.infinity,
                          child: ElevatedButton(
                              onPressed: () {
                                User currentUser;
                                setState(() {
                                  if(_firstNameCtrl.text.length == 0) {
                                    _error1 = "Enter your first name";
                                    return;
                                  }
                                  if(_lastNameCtrl.text.length == 0){
                                    _error2 = "Enter your last name";
                                    return;
                                  }
                                  if(_emailCtrl.text.length == 0){
                                    _error2 = "Enter your email";
                                    return;
                                  }
                                  _error1 = _error2 = _error3 = null;
                                  print("Todo nice");
                                  currentUser = new User();
                                  currentUser.first_name = _firstNameCtrl.text;
                                  currentUser.last_name = _lastNameCtrl.text;
                                  currentUser.email = _emailCtrl.text;
                                  Provider.of<SakilaProvider>(context, listen: false).setUserInProgress(currentUser);
                                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => AddressSignup()), (route) => false);
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 18.0),
                                child: Text('Continue...', style: TextStyle(color: Colors.white),),
                              )
                          ),
                        ),
                        SizedBox(height: 10.0,),
                        Container(
                          child: FlatButton(
                            onPressed: (){
                              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => LoginForm()), (route) => false);
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10.0),
                              child: Text('Already registered? Login!', style: TextStyle(color: Colors.blueAccent, decoration: TextDecoration.underline),),
                            ),
                          ),
                        ),
                        Container(
                          child: FlatButton(
                            onPressed: (){
                              String before = Provider.of<SakilaProvider>(context, listen: false).getPrevious();
                              if(before == "home")
                                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => HomePage()), (route) => false);
                              else if(before == "payment")
                                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => ShoppingCart()), (route) => false);
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10.0),
                              child: Text('Cancel', style: TextStyle(color: Colors.red, decoration: TextDecoration.underline),),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

