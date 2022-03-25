import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grocery/AuthService.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'HomePage.dart';

class Login extends StatefulWidget {
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
  String error = "";

  @override
  void initState() {
    super.initState();
  }

  bool _isObscure = true;
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    GoogleSignInAccount? user = _googleSignIn.currentUser;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
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
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              Container(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      text: "Welcome, Merchant",
                      style: TextStyle(
                          fontSize: mediaQueryData.textScaleFactor /
                              mediaQueryData.textScaleFactor *
                              33,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          color: Colors.black)),
                ),
              ),

              Container(
                child: Image(
                    image: AssetImage("images/login.png"), fit: BoxFit.contain),
              ),

              Container(
                  width: mediaQueryData.size.width * 0.85,
                  child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                            TextFormField(
                                controller: _emailController,
                                validator: (input) {
                                  if (input!.isEmpty)
                                    return 'Pleas enter a valid Email';
                                },
                                decoration: InputDecoration(
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red),
                                  ),
                                  errorStyle: TextStyle(height: 0.4),
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 20.0),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xff2C6846))),
                                  focusColor: Color(0xff2C6846),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                    color: Color(0xff2C6846),
                                  )),
                                  labelStyle:
                                      TextStyle(color: Color(0xff2C6846)),
                                  labelText: "Email",
                                  prefixIcon: Icon(Icons.mail,
                                      color: Color(0xff2C6846)),
                                ),
                                onSaved: (input) => _email = input!),
                            SizedBox(height: 20),
                            TextFormField(
                                obscureText: _isObscure,
                                enableSuggestions: false,
                                autocorrect: false,
                                controller: _passwordController,
                                validator: (input) {
                                  if (input!.length < 6)
                                    return 'Provide minimum 6 character';
                                },
                                decoration: InputDecoration(
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.red),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.red),
                                    ),
                                    errorStyle: TextStyle(height: 0.4),
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 20.0),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xff2C6846))),
                                    focusColor: Color(0xff2C6846),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xff2C6846))),
                                    labelStyle:
                                        TextStyle(color: Color(0xff2C6846)),
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
                                    prefixIcon: Icon(Icons.lock,
                                        color: Color(0xff2C6846))),
                                onSaved: (input) => _password = input!),
                          ])))),
              SizedBox(height: 20),
              ButtonTheme(
                buttonColor: Color(0xff2C6846),
                minWidth: mediaQueryData.size.width * 0.85,
                height: 60.0,
                child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(5.0),
                    ),
                    padding: EdgeInsets.fromLTRB(70, 10, 70, 10),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        signInUser();
                      }
                    },
                    child: Text('Log In',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w600))),
              )

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
        context, _emailController.text, _passwordController.text);
    if (authResult == null) {
      print("Sign in error. Could not be able to login");
    } else {
      showFlash(
        context: context,
        duration: const Duration(seconds: 2),
        builder: (context, controller) {
          return Flash.bar(
            controller: controller,
            backgroundColor: Colors.green,
            position: FlashPosition.top,
            child: Container(
                width: MediaQuery.of(context).size.width,
                height: 70,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Sign In Successfully",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ],
                )),
          );
        },
      );
      _emailController.clear();
      _passwordController.clear();
      await Future.delayed(const Duration(seconds: 2), () {});
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => HomePage()),
          (Route<dynamic> route) => false);
    }
  }
}
