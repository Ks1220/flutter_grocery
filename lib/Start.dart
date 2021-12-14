import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

import 'Login.dart';
import 'SignUp.dart';

class Start extends StatefulWidget {
  const Start({Key? key}) : super(key: key);

  @override
  _StartState createState() => _StartState();
}

class _StartState extends State<Start> {
  navigateToLogin() async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
  }

  navigateToSignup() async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Image.asset('images/logo-name.png'),
          backgroundColor: new Color(0xffff),
          shadowColor: Colors.transparent,
          elevation: 0,
          toolbarHeight: 90.0,
        ),

        body: Container(
            child: Column(children: <Widget>[
          Container(
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                  text: "Made e-Groceries easier",
                  style: TextStyle(
                      fontSize: 37,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      color: Colors.black)),
            ),
            width: 350,
          ),

          Container(
              child: Image(
                  image: AssetImage("images/login.png"), fit: BoxFit.contain)),

          SizedBox(height: 20.0),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    child: ButtonTheme(
                      minWidth: 337.0,
                      height: 53.0,
                      child: RaisedButton(
                          onPressed: navigateToLogin,
                          child: Text("Log In",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          color: Color.fromRGBO(44, 104, 70, 1)),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: ButtonTheme(
                      minWidth: 337.0,
                      height: 53.0,
                      child: RaisedButton(
                        onPressed: navigateToSignup,
                        child: Text("Sign Up",
                            style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w600)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 40.0),

          Container(
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                  text:
                      "By signing in, you agree to our Terms of Service and Privacy Policy",
                  style: TextStyle(
                      fontSize: 13, fontFamily: 'Roboto', color: Colors.black)),
            ),
            width: 300,
          ),
        ])));
  }
}
