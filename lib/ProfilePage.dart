import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';

import 'Start.dart';

class ProfilePage extends StatefulWidget {
  final User? currentUser;
  const ProfilePage(this.currentUser, {Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  getData() async {
    var firestore = FirebaseFirestore.instance;
    DocumentSnapshot qn = await firestore
        .collection('MerchantData')
        .doc(widget.currentUser?.uid)
        .get();
    return qn.data();
  }

  showLogOutDialog() async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Log out'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Are you sure you want to log out?.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'Ok',
                style: TextStyle(color: Color(0xff2C6846)),
              ),
              onPressed: () async {
                try {
                  await FirebaseAuth.instance.signOut().then((value) async => {
                        showFlash(
                          context: context,
                          duration: const Duration(seconds: 3),
                          builder: (context, controller) {
                            return Flash.bar(
                              controller: controller,
                              backgroundColor: Colors.green,
                              position: FlashPosition.top,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    80.0, 20.0, 80.0, 20.0),
                                child: Text(
                                  "Log Out Successfully",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        Future.delayed(const Duration(seconds: 2), () {
                          Navigator.of(context).pop();
                        }).then((value) => {
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => Start()),
                                  (Route<dynamic> route) => false)
                            })
                      });
                } catch (e) {
                  print("Error: $e");
                }
              },
            ),
          ],
        );
      },
    );
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
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FutureBuilder(
              future: getData(),
              builder: (BuildContext context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                      height: MediaQuery.of(context).size.width,
                      child: Align(
                        alignment: Alignment.center,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return Column(// here only return is missing
                        children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 10.0, 0, 20),
                        child: CircleAvatar(
                          radius: 50.0,
                          child: ClipRRect(
                            child: Image(
                              height: 100,
                              width: 100,
                              image: NetworkImage((snapshot.data
                                  as Map<String, dynamic>)['shopLogo']),
                              fit: BoxFit.fill,
                            ),
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 30),
                          child: Text(
                            "Change Profile Photo",
                            style: const TextStyle(
                              color: Colors.blue,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      ListTile(
                        shape: Border(
                          top: BorderSide(
                              color: Color.fromARGB(255, 199, 199, 199),
                              width: 1),
                        ),
                        leading: (Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Merchant Name",
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w700),
                            ),
                          ],
                        )),
                        trailing: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: <Widget>[
                            Text(
                              (snapshot.data as Map<String, dynamic>)['name'],
                              style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey),
                            ),
                            Icon(
                              Icons.chevron_right,
                              size: 26,
                              color: Colors.black,
                            )
                          ],
                        ),
                      ),
                      ListTile(
                        shape: Border(
                            top: BorderSide(
                                color: Color.fromARGB(255, 199, 199, 199),
                                width: 1),
                            bottom: BorderSide(
                                color: Color.fromARGB(255, 199, 199, 199),
                                width: 1)),
                        leading: (Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Store Name",
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w700),
                            ),
                          ],
                        )),
                        trailing: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: <Widget>[
                            Text(
                              (snapshot.data
                                  as Map<String, dynamic>)['storeName'],
                              style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey),
                            ),
                            Icon(
                              Icons.chevron_right,
                              size: 26,
                              color: Colors.black,
                            )
                          ],
                        ),
                      ),
                      ListTile(
                        shape: Border(
                            bottom: BorderSide(
                                color: Color.fromARGB(255, 199, 199, 199),
                                width: 1)),
                        leading: (Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Email",
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w700),
                            ),
                          ],
                        )),
                        trailing: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: <Widget>[
                            Text(
                              (snapshot.data as Map<String, dynamic>)['email'],
                              style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      ListTile(
                        shape: Border(
                            bottom: BorderSide(
                                color: Color.fromARGB(255, 199, 199, 199),
                                width: 1)),
                        leading: (Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Address",
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w700),
                            ),
                          ],
                        )),
                        trailing: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              width: 160.0,
                              child: Text(
                                (snapshot.data
                                    as Map<String, dynamic>)['storeAddress'],
                                overflow: TextOverflow.fade,
                                softWrap: false,
                                style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey),
                              ),
                            ),
                            Icon(
                              Icons.chevron_right,
                              size: 26,
                              color: Colors.black,
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      ListTile(
                        shape: Border(
                            top: BorderSide(
                                color: Color.fromARGB(255, 199, 199, 199),
                                width: 1),
                            bottom: BorderSide(
                                color: Color.fromARGB(255, 199, 199, 199),
                                width: 1)),
                        leading: (Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Change Password",
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w700),
                            ),
                          ],
                        )),
                        trailing: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.chevron_right,
                              size: 26,
                              color: Colors.black,
                            )
                          ],
                        ),
                      ),
                    ]);
                  }
                } else if (snapshot.hasError) {
                  return Text('no data');
                }
                return CircularProgressIndicator();
              },
            ),
            Expanded(
              child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 20),
                    child: ButtonTheme(
                      buttonColor: Color(0xff2C6846),
                      minWidth: MediaQuery.of(context).size.width * 0.92,
                      height: 55.0,
                      child: RaisedButton(
                        padding: EdgeInsets.fromLTRB(70, 10, 70, 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(5.0),
                        ),
                        onPressed: () {
                          showLogOutDialog();
                        },
                        child: Text('Log Out',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600)),
                      ),
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
