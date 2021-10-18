import 'package:flutter/material.dart';
import 'package:flutter_grocery/HomePage.dart';
import 'SignUp.dart';
import 'Start.dart';
import 'Login.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(scaffoldBackgroundColor: Colors.white),
      debugShowCheckedModeBanner: false,
      home: Start(),
    );
  }
}
