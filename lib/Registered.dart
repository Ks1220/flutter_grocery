import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_grocery/Home.dart';

import 'HomePage.dart';

class Registered extends StatefulWidget {
  const Registered({Key? key}) : super(key: key);

  @override
  _RegisteredState createState() => _RegisteredState();
}

class _RegisteredState extends State<Registered> {
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
                    text: "Registered ",
                    style: TextStyle(
                        fontSize: mediaQueryData.textScaleFactor /
                            mediaQueryData.textScaleFactor *
                            30,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                    children: [
                      TextSpan(
                        text: 'Successfully',
                        style: TextStyle(color: Color(0xff2C6846)),
                      ),
                    ]),
              ),
              width: mediaQueryData.size.width * 0.8,
            ),
            Container(
              child: Image(
                  image: AssetImage("images/registered.png"),
                  fit: BoxFit.contain),
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
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => Home()),
                      (Route<dynamic> route) => false);
                },
                child: Text('Done',
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
}
