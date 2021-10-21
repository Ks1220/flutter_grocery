import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_grocery/AuthService.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:flutter_signin_button/flutter_signin_button.dart';
// import 'package:provider/provider.dart';
import 'HomePage.dart';

class Login extends StatefulWidget {
  // const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  late String _email, _password;

  @override
  void initState() {
    super.initState();
  }

  showError(String errormessage) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text('Error'),
              content: Text(errormessage),
              actions: <Widget>[
                FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'))
              ]);
        });
  }

  @override
  Widget build(BuildContext context) {
    GoogleSignInAccount? user = _googleSignIn.currentUser;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Column(
            children: [
              Container(
                height: 200,
                child: Image(
                  image: AssetImage("images/login.png"),
                ),
              ),
              Container(
                  child: Form(
                      key: _formKey,
                      child: Column(children: [
                        TextFormField(
                            controller: _emailController,
                            validator: (input) {
                              if (input!.isEmpty) return 'Enter Email';
                            },
                            decoration: InputDecoration(
                                labelText: "Email",
                                prefixIcon: Icon(Icons.mail)),
                            onSaved: (input) => _email = input!),
                        TextFormField(
                            controller: _passwordController,
                            validator: (input) {
                              if (input!.length < 6)
                                return 'Provide minimum 6 character';
                            },
                            decoration: InputDecoration(
                                labelText: "Password",
                                prefixIcon: Icon(Icons.lock)),
                            onSaved: (input) => _password = input!),
                      ]))),
              RaisedButton(
                  padding: EdgeInsets.fromLTRB(70, 10, 70, 10),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      signInUser();
                    }
                  },
                  child: Text('Login',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold))),
              // SignInButton(
              //   Buttons.Google,
              //   onPressed: () async {
              //     await _googleSignIn.signIn();
              //     Navigator.push(
              //       context, MaterialPageRoute(builder: (context) => HomePage()));
              //   },
              // )
            ],
          ),
        ),
      ),
    );
  }

  void signInUser() async {
    dynamic authResult = await _auth.loginUser(
        _emailController.text.trim(), _passwordController.text);
    if (authResult == null) {
      print("Sign in error. Could not be able to login");
    } else {
      _emailController.clear();
      _passwordController.clear();
      print('Sign in Successful');
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    }
  }
}
