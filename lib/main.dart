// @dart=2.9
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grocery/HomePage.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'Start.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(scaffoldBackgroundColor: Colors.white),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            body: DoubleBackToCloseApp(
          child:
              FirebaseAuth.instance.currentUser != null ? HomePage() : Start(),
          snackBar:
              const SnackBar(content: Text("Press/Swipe back again to leave")),
        )));
  }
}
