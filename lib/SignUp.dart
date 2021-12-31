// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grocery/AuthService.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_grocery/Start.dart';
// import 'package:flutter_grocery/provider/GoogleSignInProvider.dart';
// import 'package:flutter_signin_button/flutter_signin_button.dart';
// import 'package:provider/provider.dart';
import 'HomePage.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final AuthService _auth = AuthService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  late String _email, _password, _name, _confirmpass;

  @override
  void initState() {
    super.initState();
  }

  showError(String errormessage) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('ERROR'),
            content: Text(errormessage),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'))
            ],
          );
        });
  }

  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      appBar: !isKeyboard
          ? AppBar(
              titleSpacing: 12,
              leading: ModalRoute.of(context)?.canPop == true
                  ? IconButton(
                      splashColor: Colors.transparent,
                      padding: const EdgeInsets.only(left: 30.0, bottom: 15.0),
                      icon: Icon(
                        Icons.arrow_back,
                        size: 35,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      color: Colors.black,
                    )
                  : null,
              title: Image.asset('images/logo-name.png'),
              backgroundColor: new Color(0xffff),
              shadowColor: Colors.transparent,
              elevation: 0,
              toolbarHeight: 90.0,
            )
          : null,
      body: Center(
          child: Column(
        children: <Widget>[
          if (!isKeyboard) SizedBox(height: 15.0),
          if(!isKeyboard)
            Container(
              child: RichText(
                textAlign: TextAlign.left,
                text: TextSpan(
                    text: "Get Started",
                    style: TextStyle(
                        fontSize: 26,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        color: Colors.black)),
              ),
              width: mediaQueryData.size.width * 0.85,
            ),
          Container(
            child: RichText(
              textAlign: TextAlign.left,
              text: TextSpan(
                  text: "Create an account to start ordering",
                  style: TextStyle(
                      fontSize: 12,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      color: Colors.black)),
            ),
            width: mediaQueryData.size.width * 0.85,
          ),
          SizedBox(height: 50),
          Container(
            width: mediaQueryData.size.width * 0.85,
            child: Form(
                key: _formKey,
                child: Column(children: [
                  TextFormField(
                      controller: _nameController,
                      validator: (input) {
                        if (input!.isEmpty) return 'Enter Name';
                      },
                      decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 20.0),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff2C6846))),
                          focusColor: Color(0xff2C6846),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                            color: Color(0xff2C6846),
                          )),
                          labelStyle: TextStyle(color: Color(0xff2C6846)),
                          labelText: "Full Name",
                          prefixIcon:
                              Icon(Icons.person, color: Color(0xff2C6846))),
                      onSaved: (input) => _name = input!),
                  SizedBox(height: 25),
                  TextFormField(
                      controller: _emailController,
                      validator: (input) {
                        if (input!.isEmpty) return 'Enter Email';
                      },
                      decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 20.0),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff2C6846))),
                          focusColor: Color(0xff2C6846),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                            color: Color(0xff2C6846),
                          )),
                          labelStyle: TextStyle(color: Color(0xff2C6846)),
                          labelText: "Email",
                          prefixIcon:
                              Icon(Icons.mail, color: Color(0xff2C6846))),
                      onSaved: (input) => _name = input!),
                  SizedBox(height: 25),
                  TextFormField(
                      obscureText: _isObscure,
                      controller: _passwordController,
                      validator: (input) {
                        if (input!.length < 6)
                          return 'Provide minimum 6 character';
                      },
                      decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 20.0),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff2C6846))),
                          focusColor: Color(0xff2C6846),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                            color: Color(0xff2C6846),
                          )),
                          labelStyle: TextStyle(color: Color(0xff2C6846)),
                          labelText: "Password",
                          suffixIcon: IconButton(
                                    icon: Icon(
                                      _isObscure
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Color(0xff2C6846),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isObscure = !_isObscure;
                                      });
                                    },
                                  ),
                          prefixIcon:
                              Icon(Icons.lock, color: Color(0xff2C6846))
                          ),

                      onSaved: (input) => _password = input!),
                  SizedBox(height: 25),
                  TextFormField(
                      controller: _confirmPasswordController,
                      validator: (input) {
                        if (input!.length < 6)
                          return 'Provide minimum 6 character';
                        if (input != _passwordController.text)
                          return 'Password not match';
                      },
                      decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 20.0),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff2C6846))),
                          focusColor: Color(0xff2C6846),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                            color: Color(0xff2C6846),
                          )),
                          labelStyle: TextStyle(color: Color(0xff2C6846)),
                          labelText: "Confirm Password",
                          prefixIcon:
                              Icon(Icons.vpn_key, color: Color(0xff2C6846))),
                      obscureText: true,
                      onSaved: (input) => _password = input!),
                ])),
          ),
          SizedBox(height: 30),
          ButtonTheme(
            buttonColor: Color(0xff2C6846),
            minWidth: mediaQueryData.size.width * 0.85,
            height: 60.0,
            child: RaisedButton(
              padding: EdgeInsets.fromLTRB(70, 10, 70, 10),
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(5.0),
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _firebaseAuth
                      .createUserWithEmailAndPassword(
                          email: _emailController.text,
                          password: _passwordController.text)
                      .then((value) {
                    FirebaseFirestore.instance
                        .collection('UserData')
                        .doc(value.user!.uid)
                        .set({
                      "email": value.user!.email,
                      "name": _nameController.text
                    });
                  });
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => HomePage()));
                }
              },
              child: Text('Sign Up',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600)),
            ),
          ),
          SizedBox(height: 10.0),
          Container(
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                  text:
                      "By signing in, you agree to our Terms of Service and Privacy Policy",
                  style: TextStyle(
                      fontSize: 11, fontFamily: 'Roboto', color: Colors.black)),
            ),
            width: 300,
          ),
          // SignInButton(
          //       Buttons.Google,
          //       onPressed: () {
          //         // final provider =
          //         //     Provider.of<GoogleSignInProvider>(context, listen: false);
          //         // provider.login();
          //       },
          //     )
        ],
      )),
    );
  }
}
