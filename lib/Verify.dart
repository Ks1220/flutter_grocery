import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grocery/Login.dart';
import 'package:flutter_grocery/Registered.dart';

class Verify extends StatefulWidget {
  const Verify({Key? key}) : super(key: key);

  @override
  _VerifyState createState() => _VerifyState();
}

class _VerifyState extends State<Verify> {
  final auth = FirebaseAuth.instance;
  late User user;
  late Timer timer;

  // late final GestureRecognizer? recognizer;

  @override
  void initState() {
    user = auth.currentUser!;
    user.sendEmailVerification();

    timer = Timer.periodic(Duration(seconds: 5), (timer) {
      checkEmailVerified();
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
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
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    text: "Check your inbox",
                    style: TextStyle(
                        fontSize: mediaQueryData.textScaleFactor /
                            mediaQueryData.textScaleFactor *
                            30,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        color: Colors.black)),
              ),
              width: mediaQueryData.size.width * 0.8,
            ),
            Container(
              child: Image(
                  image: AssetImage("images/check-inbox.png"),
                  fit: BoxFit.contain),
            ),
            SizedBox(height: 40),
            Container(
              child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      text:
                          "Check your inbox! We have sent you a link to activate your account! \n\n",
                      style: TextStyle(
                          fontSize: mediaQueryData.textScaleFactor /
                              mediaQueryData.textScaleFactor *
                              16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                      children: [
                        TextSpan(
                            text:
                                "Once verified, you will be able to enjoy all the most exciting feature such as uploading your grocery product into our application!"),
                      ])),
              width: mediaQueryData.size.width * 0.85,
            ),
            SizedBox(height: 20),
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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => Login()));
                },
                child: Text('Next',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> checkEmailVerified() async {
    user = auth.currentUser!;
    await user.reload();
    if (user.emailVerified) {
      timer.cancel();
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context) => Registered()));
    }
  }
}
