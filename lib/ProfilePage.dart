import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:alphabet_scroll_view/alphabet_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grocery/databaseManager/DatabaseManager.dart';

import 'AddItem.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User user;
  User? currentUser = FirebaseAuth.instance.currentUser;
  TextEditingController searchController = TextEditingController();

  bool isLoggedin = true;
  bool _isEdit = false;

  List groceryItemList = [];
  List nameList = [];
  List itemsIdList = [];
  List items = [];

  late List groceries;

  @override
  void initState() {
    super.initState();
    fetchGroceryItemList();
    fetchItemId();
    searchController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  fetchGroceryItemList() async {
    dynamic resultant = await DatabaseManager().getGroceryList(currentUser);
    if (resultant == null) {
      print("Unable to retrieve");
    } else {
      setState(() {
        groceryItemList = resultant;
        groceryItemList.forEach((e) => nameList.add(e["itemName"]));
        items.addAll(groceryItemList);
      });
    }
  }

  fetchItemId() async {
    Query itemId = FirebaseFirestore.instance
        .collection('Items')
        .doc(currentUser!.uid)
        .collection('Item')
        .orderBy("itemName");

    await itemId.get().then((docs) {
      setState(() {
        docs.docs.forEach((doc) => {itemsIdList.add(doc.id)});
      });
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

  void filterSearchResults(String query) {
    List<dynamic> dummyData = [];
    dummyData.addAll(items);
    List<QueryDocumentSnapshot> dummySearchResult = [];

    if (query.isNotEmpty) {
      dummyData.forEach((item) {
        if (item["itemName"].toLowerCase().contains(query) ||
            item["itemName"].contains(query)) {
          dummySearchResult.add(item);
        }
      });
      setState(() {
        items.clear();
        items.addAll(dummySearchResult);
      });
      return;
    } else {
      setState(() {
        items.clear();
        items.addAll(groceryItemList);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;

    return Scaffold(
      appBar: !isKeyboard
          ? AppBar(
              toolbarHeight: 65.0,
              iconTheme: IconThemeData(
                color: Color(0xff2C6846), //change your color here
              ),
              title: const Text('My Profile',
                  style: TextStyle(color: Colors.black)),
              elevation: 0,
              backgroundColor: Colors.white,
            )
          : null,
      body: Container(
        child: Column(
          children: [
            IconButton(
              splashColor: Colors.transparent,
              padding: const EdgeInsets.only(left: 30.0, bottom: 15.0),
              icon: Icon(
                Icons.arrow_back,
                size: 35,
              ),
              onPressed: () => Navigator.of(context).pop(),
              color: Colors.black,
            )
          ],
        ),
      ),
    );
  }
}
