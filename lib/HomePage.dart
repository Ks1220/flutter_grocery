import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grocery/databaseManager/DatabaseManager.dart';

import 'AddItem.dart';
// import 'package:flutter_grocery/AddItem.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User user;
  bool isLoggedin = true;

  List userProfilesList = [];

  getUser() async {
    User? firebaseUser = _auth.currentUser;
    await firebaseUser!.reload();
    firebaseUser = _auth.currentUser!;

    if (firebaseUser != null) {
      setState(() {
        this.user = firebaseUser!;
        this.isLoggedin = true;
      });
    }
  }

  navigateToAddItem() async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => AddItem()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 65.0,
        backgroundColor: Color(0xff2C6846),
        automaticallyImplyLeading: false,
        title: const Text('Home'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.account_circle_rounded),
            tooltip: 'Open User Profile',
            iconSize: 40,
            onPressed: () {
              // handle the press
            },
          ),
        ],
      ),
      body: Container(
        child: Column(
          children: [],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: navigateToAddItem,
        tooltip: 'Add Grocery Item',
        backgroundColor: Color(0xff2C6846),
        child: Icon(Icons.add),
      ),
    );
  }
}
