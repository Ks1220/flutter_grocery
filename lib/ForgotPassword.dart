import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grocery/AuthService.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'EmailConfirmation.dart';
import 'HomePage.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();

  late String _email;
  String error = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);

    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              if (!isKeyboard)
                Container(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        text: "Forgot Password",
                        style: TextStyle(
                            fontSize: mediaQueryData.textScaleFactor /
                                mediaQueryData.textScaleFactor *
                                33,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            color: Colors.black)),
                  ),
                  width: mediaQueryData.size.width * 0.8,
                ),
              SizedBox(
                height: 10,
              ),
              Container(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      text:
                          "Submit your email to receive instructions to reset password",
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          color: Colors.black)),
                ),
                width: mediaQueryData.size.width * 0.8,
              ),
              Container(
                child: Image(
                    image: AssetImage("images/forgot-password.png"),
                    fit: BoxFit.contain),
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
                    padding: EdgeInsets.fromLTRB(50, 10, 50, 10),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        resetPassword()
                            .then((value) => {_emailController.clear()});
                      }
                    },
                    child: Text('Next',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w600))),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future resetPassword() async {
    await FirebaseAuth.instance
        .sendPasswordResetEmail(email: _emailController.text.trim())
        .then((value) => {
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
                              "Password Reset Email Sent",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        )),
                  );
                },
              ).then((value) => {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => EmailConfirmation()))
                  })
            });
  }
}
