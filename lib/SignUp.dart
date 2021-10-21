// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grocery/AuthService.dart';
// import 'package:firebase_core/firebase_core.dart';
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
  final _formKey = GlobalKey<FormState>();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
          child: Column(
        children: [
          SizedBox(height: 50),
          Form(
              key: _formKey,
              child: Column(children: [
                TextFormField(
                    controller: _nameController,
                    validator: (input) {
                      if (input!.isEmpty) return 'Enter Name';
                    },
                    decoration: InputDecoration(
                        labelText: "Name", prefixIcon: Icon(Icons.person)),
                    onSaved: (input) => _name = input!),
                TextFormField(
                    controller: _emailController,
                    validator: (input) {
                      if (input!.isEmpty) return 'Enter Email';
                    },
                    decoration: InputDecoration(
                        labelText: "Email", prefixIcon: Icon(Icons.mail)),
                    onSaved: (input) => _name = input!),
                TextFormField(
                    controller: _passwordController,
                    validator: (input) {
                      if (input!.length < 6)
                        return 'Provide minimum 6 character';
                    },
                    decoration: InputDecoration(
                        labelText: "Password", prefixIcon: Icon(Icons.lock)),
                    obscureText: true,
                    onSaved: (input) => _password = input!),
              ])),
          SizedBox(height: 20),
          RaisedButton(
            padding: EdgeInsets.fromLTRB(70, 10, 70, 10),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                createUser();
              }
            },
            child: Text('SignUp',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold)),
            color: Colors.orange,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
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
    ));
  }

  void createUser() async {
    dynamic result = await _auth.createNewUser(
        _emailController.text.trim(), _passwordController.text);
    if (result == null) {
      print('Email is not valid');
    } else {
      print(result.toString());
      _nameController.clear();
      _passwordController.clear();
      _emailController.clear();
      Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePage()));
    }
  }
}
