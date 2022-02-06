import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grocery/databaseManager/DatabaseManager.dart';

import 'Start.dart';

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

  checkAuthentification() async {
    _auth.authStateChanges().listen((user) {
      if (user == null) {
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => Start()));
      }
    });
  }

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

  signOut() async {
    _auth.signOut();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.checkAuthentification();
    this.getUser();
    // fetchDatabaseList();
  }

  // fetchDatabaseList() async {
  //   dynamic resultant = await DatabaseManager().getUserList();

  //   if (resultant == null) {
  //     print('Unable to retrieve');
  //   } else {
  //     setState(() {
  //       userProfilesList = resultant;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: !isLoggedin
          ? CircularProgressIndicator()
          : Column(
              children: [
                Container(
                    height: 400,
                    child: Image(
                      image: AssetImage("images/welcome.png"),
                      fit: BoxFit.contain,
                    )),
                Container(
                  child: Text(
                      (userProfilesList.length > 0
                          ? "Hello ${userProfilesList[0]['name']} you are Logged in as ${user.email}"
                          : ""),
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold)),
                ),
                RaisedButton(
                    padding: EdgeInsets.fromLTRB(70, 10, 70, 10),
                    onPressed: signOut,
                    child: Text('Sign Out',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold)))
              ],
            ),
    ));
  }
}
