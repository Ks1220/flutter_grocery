import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/src/iterable_extensions.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:collection/collection.dart';

import 'AddItem.dart';

import 'databaseManager/DatabaseManager.dart';

class MyOrders extends StatefulWidget {
  const MyOrders({Key? key}) : super(key: key);

  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  User? user = FirebaseAuth.instance.currentUser;
  List storeId = [];

  List groceryItemList = [];
  List items = [];

  @override
  void initState() {
    super.initState();
    fetchGroceryItemList();
  }

  fetchGroceryItemList() async {
    Query query = FirebaseFirestore.instance
        .collection('MerchantOrders')
        .doc(user!.uid)
        .collection('Items')
        .orderBy("userId");
    List itemsList = [];
    await query.get().then((docs) {
      docs.docs.forEach((doc) {
        itemsList.add(doc);
        print("THIS IS ITEMLIST: $itemsList");
      });
    });

    dynamic resultant = itemsList;

    if (resultant == null) {
      print("Unable to retrieve");
    } else {
      setState(() {
        groceryItemList = resultant;
        items.addAll(groceryItemList);
      });
    }
  }

  getData() async {
    var firestore = FirebaseFirestore.instance;
    DocumentSnapshot qn =
        await firestore.collection('MerchantData').doc(user?.uid).get();

    return qn.data();
  }

  getName(userId) async {
    String userName;
    DocumentReference user =
        FirebaseFirestore.instance.collection('UserData').doc(userId);

    user.get().then((docs) {
      return ("THIS IS NAME: ${docs["name"]}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 65.0,
          iconTheme: IconThemeData(
            color: Color(0xff2C6846), //change your color here
          ),
          title: const Text('My Orders', style: TextStyle(color: Colors.black)),
          elevation: 0,
          backgroundColor: Colors.white,
        ),
        body: items.length == 0
            ? Container(
                height: MediaQuery.of(context).size.width,
                child: Align(
                  alignment: Alignment.center,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                          width: 100,
                          height: 100,
                          image: AssetImage("images/empty-guide.png"),
                          fit: BoxFit.contain),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                          width: 170,
                          child: Text(
                            "No Orders Yet",
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 17,
                                fontWeight: FontWeight.w600),
                            textAlign: TextAlign.center,
                          ))
                    ],
                  ),
                ),
              )
            : Stack(fit: StackFit.expand, children: [
                SingleChildScrollView(
                  child: FutureBuilder(
                    future: getData(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.connectionState ==
                            ConnectionState.done) {
                          return Column(children: [
                            Row(
                              children: [
                                Container(
                                  alignment: Alignment.topLeft,
                                  margin: EdgeInsets.only(left: 10, top: 5),
                                  child: Text(
                                    "Order #00001",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ],
                            ),
                            StreamBuilder(
                                stream:
                                    DatabaseManager().getOrderList(user!.uid),
                                builder: (context, AsyncSnapshot snapshot) {
                                  if (snapshot.hasData) {
                                    return ListView.separated(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      separatorBuilder: (_, __) => Container(
                                          height: 2.0, color: Colors.grey[300]),
                                      itemCount: snapshot.data!.docs.length,
                                      itemBuilder: (ctx, index) {
                                        return Container(
                                          margin:
                                              EdgeInsets.fromLTRB(0, 15, 0, 15),
                                          child: ListTile(
                                              title: Text(
                                                "${snapshot.data!.docs[index]["itemName"]}",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                              subtitle: RichText(
                                                text: TextSpan(
                                                  children: [
                                                    WidgetSpan(
                                                      child:
                                                          SizedBox(height: 20),
                                                    ),
                                                    TextSpan(
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                        text:
                                                            "RM ${(snapshot.data!.docs[index]["itemCount"] * double.parse(snapshot.data!.docs[index]["price"]))} \n"),
                                                    WidgetSpan(
                                                      child:
                                                          SizedBox(height: 40),
                                                    ),
                                                    WidgetSpan(
                                                      child: Icon(
                                                        Icons.account_circle,
                                                        color: Colors.black54,
                                                      ),
                                                    ),
                                                    WidgetSpan(
                                                      child:
                                                          Transform.translate(
                                                        offset: const Offset(
                                                            0.0, -3.0),
                                                        child: Text(
                                                          " ${snapshot.data!.docs[index]["userName"]}",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black54),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              leading: CachedNetworkImage(
                                                width: 65,
                                                height: 120,
                                                imageUrl: snapshot.data!
                                                    .docs[index]["itemImage"],
                                                progressIndicatorBuilder:
                                                    (context, url,
                                                            downloadProgress) =>
                                                        SizedBox(
                                                  width: 65,
                                                  height: 120,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.black26,
                                                    ),
                                                  ),
                                                ),
                                                fit: BoxFit.fill,
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Icon(Icons.error),
                                              ),
                                              trailing: Transform.translate(
                                                offset: const Offset(0.0, 20.0),
                                                child: Wrap(
                                                  crossAxisAlignment:
                                                      WrapCrossAlignment.center,
                                                  alignment:
                                                      WrapAlignment.spaceEvenly,
                                                  children: <Widget>[
                                                    Text(
                                                        'x ${snapshot.data!.docs[index]["itemCount"]}',
                                                        style: new TextStyle(
                                                            fontSize: 20.0)),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    SizedBox(
                                                      width: 20,
                                                    ),
                                                  ],
                                                ),
                                              )),
                                        );
                                      },
                                    );
                                  } else if (snapshot.hasError) {
                                    return Text('no data');
                                  } else {
                                    return Center(
                                        child: CircularProgressIndicator());
                                  }
                                }),
                            SizedBox(height: 100)
                          ]);
                        }
                      } else if (snapshot.hasError) {
                        return Text('no data');
                      }
                      return Center(child: CircularProgressIndicator());
                    },
                  ),
                ),
              ]));
  }
}
