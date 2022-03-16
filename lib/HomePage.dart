import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:alphabet_scroll_view/alphabet_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grocery/ProfilePage.dart';
import 'package:flutter_grocery/databaseManager/DatabaseManager.dart';

import 'AddItem.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => ProfilePage()));
            },
          ),
        ],
      ),
      body: Column(children: [
        Container(
          width: 350.0,
          margin: EdgeInsets.fromLTRB(10, 20, 10, 10),
          child: TextField(
            onChanged: (value) {
              filterSearchResults(value);
            },
            controller: searchController,
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    searchController.clear();
                  },
                ),
                hintText: 'Search...',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                )),
          ),
        ),
        Expanded(
            child: searchController.text.length > 0
                ? ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (ctx, index) {
                      return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    AddItem(!_isEdit, itemsIdList[index])));
                          },
                          child: Container(
                              padding:
                                  const EdgeInsets.fromLTRB(0.0, 10.0, 30, 0.0),
                              height: 90,
                              child: ListTile(
                                shape: Border(
                                    bottom: BorderSide(
                                        color:
                                            Color.fromARGB(255, 199, 199, 199),
                                        width: 1)),
                                title: Text(items.length > 0
                                    ? "${items[index]["itemName"]}"
                                    : ""),
                                subtitle: Text(items.length > 0
                                    ? "${items[index]["price"]}/${items[index]["measurementMatrix"]}"
                                    : ""),
                                leading: (Image(
                                    width: 65,
                                    height: 65,
                                    fit: BoxFit.fill,
                                    image: NetworkImage(
                                        items[index]["itemImage"]))),
                                trailing: Text(items.length > 0
                                    ? "Stock: ${items[index]["stockAmount"]}"
                                    : ""),
                              )));
                    },
                  )
                : AlphabetScrollView(
                    list: nameList.map((e) => AlphaModel(e)).toList(),
                    alignment: LetterAlignment.right,
                    itemExtent: 150,
                    unselectedTextStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: Colors.black),
                    selectedTextStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff2C6846)),
                    overlayWidget: (value) => Stack(
                      alignment: Alignment.center,
                      children: [
                        Icon(
                          Icons.star,
                          size: 50,
                          color: Colors.red,
                        ),
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '$value'.toUpperCase(),
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    itemBuilder: (_, index, buildContext) {
                      return (GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    AddItem(!_isEdit, itemsIdList[index])));
                          },
                          child: Container(
                              padding:
                                  const EdgeInsets.fromLTRB(0.0, 10.0, 30, 0.0),
                              height: 90,
                              child: ListTile(
                                shape: Border(
                                    bottom: BorderSide(
                                        color:
                                            Color.fromARGB(255, 199, 199, 199),
                                        width: 1)),
                                title: Text(items[index] != null
                                    ? "${items[index]["itemName"]}"
                                    : ""),
                                subtitle: Text(items[index] != null
                                    ? "${items[index]["price"]}/${items[index]["measurementMatrix"]}"
                                    : ""),
                                leading: (Image(
                                    width: 65,
                                    height: 65,
                                    fit: BoxFit.fill,
                                    image: NetworkImage(
                                        items[index]["itemImage"]))),
                                trailing: Text(items[index] != null
                                    ? "Stock: ${items[index]["stockAmount"]}"
                                    : ""),
                              ))));
                    },
                  ))
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AddItem(_isEdit, "testing")));
        },
        tooltip: 'Add Grocery Item',
        backgroundColor: Color(0xff2C6846),
        child: Icon(Icons.add),
      ),
    );
  }
}
