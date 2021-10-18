import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'HomePage.dart';

class Login extends StatefulWidget {
  // const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _email = "", _password = "";

  checkAuthentification() async {
    _auth.onAuthStateChanged.listen((user) {
      if (user != null) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      }
    });

    @override
    void initState() {
      super.initState();
      this.checkAuthentification();
    }
  }

  login() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        FirebaseUser user = (await _auth.signInWithEmailAndPassword(
            email: _email, password: _password)) as FirebaseUser;
      } catch (e) {
        showError(e.toString());
      }
    }
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
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Column(
            children: [
              Container(
                height: 200,
                child: Image(
                  image: AssetImage("images/welcome.png"),
                ),
              ),
              Container(
                  child: Form(
                      key: _formKey,
                      child: Column(children: [
                        TextFormField(
                            validator: (input) {
                              if (input!.isEmpty) return 'Enter Email';
                            },
                            decoration: InputDecoration(
                                labelText: "Email",
                                prefixIcon: Icon(Icons.mail)),
                            onSaved: (input) => _email = input!),
                        TextFormField(
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
                  onPressed: login,
                  child: Text('Login',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold))
              )
            ],
          ),
        ),
      ),
    );
  }
}
