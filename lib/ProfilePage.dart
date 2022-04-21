import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoder/geocoder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;

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

  final _formKey = GlobalKey<FormState>();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _storeNameController = TextEditingController();
  TextEditingController _storeAddressController = TextEditingController();

  File? _imageFile;
  late String imageUrl;

  var latitude;
  var longitude;

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
                Text('Are you sure you want to log out?'),
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
                          duration: const Duration(seconds: 2),
                          builder: (context, controller) {
                            return Flash.bar(
                              controller: controller,
                              backgroundColor: Colors.green,
                              position: FlashPosition.top,
                              child: Container(
                                  alignment: Alignment.center,
                                  width: MediaQuery.of(context).size.width,
                                  height: 70,
                                  child: Text(
                                    "Log Out Successfully",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  )),
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

  showMyDialog() async {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Align(
          alignment: FractionalOffset.bottomCenter,
          child: SimpleDialog(
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  pickImage(ImageSource.gallery);
                  Navigator.pop(context, _imageFile != null);
                },
                child: Row(children: [
                  Icon(
                    Icons.image,
                    size: 20,
                    color: Colors.black,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Select from Gallery',
                    style: TextStyle(fontSize: 15),
                  )
                ]),
              ),
              SimpleDialogOption(
                onPressed: () {
                  pickImage(ImageSource.camera);
                  Navigator.pop(context, _imageFile != null);
                },
                child: Row(children: [
                  Icon(
                    Icons.camera_alt,
                    size: 20,
                    color: Colors.black,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Take Image',
                    style: TextStyle(fontSize: 15),
                  )
                ]),
              ),
            ],
          ),
        );
      },
    );
  }

  pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      setState(() => _imageFile = File(image.path));
      String fileName = Path.basename(_imageFile!.path);

      Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child('$fileName');
      await firebaseStorageRef.putFile(File(image.path));
      setState(() async {
        imageUrl = await firebaseStorageRef.getDownloadURL();

        await FirebaseFirestore.instance
            .collection('MerchantData')
            .doc(widget.currentUser?.uid)
            .update({"shopLogo": imageUrl}).then((value) => {
                  showFlash(
                    context: context,
                    duration: const Duration(seconds: 2),
                    builder: (context, controller) {
                      return Flash.bar(
                        controller: controller,
                        backgroundColor: Colors.green,
                        position: FlashPosition.top,
                        child: Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width,
                            height: 70,
                            child: Text(
                              "Shop Logo Updated Successfully",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            )),
                      );
                    },
                  ).then((value) {
                    Future.delayed(const Duration(seconds: 2), () {});
                  })
                });
        setState(() {});
      });
      return imageUrl;
    } on PlatformException catch (e) {
      print("Failed to pick image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;

    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                _nameController.text =
                    (snapshot.data as Map<String, dynamic>)['name'];
                _storeNameController.text =
                    (snapshot.data as Map<String, dynamic>)['storeName'];
                _storeAddressController.text =
                    (snapshot.data as Map<String, dynamic>)['storeAddress'];
                imageUrl = (snapshot.data as Map<String, dynamic>)['shopLogo'];

                if (snapshot.hasData) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    return Column(children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 10.0, 0, 20),
                        child: CircleAvatar(
                          radius: 50.0,
                          child: ClipRRect(
                            child: CachedNetworkImage(
                              width: 100,
                              height: 100,
                              imageUrl: imageUrl,
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) => SizedBox(
                                width: 100,
                                height: 100,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black26,
                                  ),
                                ),
                              ),
                              fit: BoxFit.fill,
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          showMyDialog();
                        },
                        child: Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 30),
                          child: Text(
                            "Change Logo Photo",
                            style: const TextStyle(
                              color: Colors.blue,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      ListTile(
                        onTap: () {
                          showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (BuildContext context) {
                                return SingleChildScrollView(
                                    child: Container(
                                  padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom,
                                    left: 20,
                                    right: 20,
                                    top: 10,
                                  ),
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        children: [
                                          Text(
                                            'Merchant Name',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Spacer(),
                                          IconButton(
                                            icon: const Icon(Icons.close),
                                            tooltip: 'Close',
                                            iconSize: 30,
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      Form(
                                        key: _formKey,
                                        child: TextFormField(
                                          controller: _nameController,
                                          validator: (input) {
                                            if (input!.isEmpty)
                                              return 'Please enter a Name';
                                          },
                                          decoration: InputDecoration(
                                              focusedErrorBorder:
                                                  OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.red),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.red),
                                              ),
                                              errorStyle:
                                                  TextStyle(height: 0.4),
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 20.0),
                                              enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.grey)),
                                              focusColor: Colors.grey,
                                              focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                color: Colors.grey,
                                              )),
                                              labelText: "Enter Full Name",
                                              labelStyle:
                                                  TextStyle(color: Colors.grey),
                                              prefixIcon: Icon(Icons.person,
                                                  color: Colors.grey)),
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      ButtonTheme(
                                        buttonColor: Color(0xff2C6846),
                                        minWidth:
                                            MediaQuery.of(context).size.width *
                                                0.92,
                                        height: 55.0,
                                        child: RaisedButton(
                                          padding: EdgeInsets.fromLTRB(
                                              70, 10, 70, 10),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(5.0),
                                          ),
                                          onPressed: () async {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              await FirebaseFirestore.instance
                                                  .collection('MerchantData')
                                                  .doc(widget.currentUser?.uid)
                                                  .update({
                                                "name": _nameController.text,
                                              }).then((value) => showFlash(
                                                        context: context,
                                                        duration:
                                                            const Duration(
                                                                seconds: 2),
                                                        builder: (context,
                                                            controller) {
                                                          return Flash.bar(
                                                            controller:
                                                                controller,
                                                            backgroundColor:
                                                                Colors.green,
                                                            position:
                                                                FlashPosition
                                                                    .top,
                                                            child: Container(
                                                                width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                                height: 70,
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Text(
                                                                      "Merchant Name Updated Successfully",
                                                                      style:
                                                                          const TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            18,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                )),
                                                          );
                                                        },
                                                      ));
                                              Future.delayed(
                                                  const Duration(seconds: 2),
                                                  () {});
                                              Navigator.of(context).pop();
                                            }
                                          },
                                          child: Text('Save',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600)),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 30,
                                      )
                                    ],
                                  ),
                                ));
                              });
                        },
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
                        onTap: () {
                          showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (BuildContext context) {
                                return SingleChildScrollView(
                                    child: Container(
                                  padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom,
                                    left: 20,
                                    right: 20,
                                    top: 10,
                                  ),
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        children: [
                                          Text(
                                            'Store Name',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Spacer(),
                                          IconButton(
                                            icon: const Icon(Icons.close),
                                            tooltip: 'Close',
                                            iconSize: 30,
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      Form(
                                        key: _formKey,
                                        child: TextFormField(
                                          controller: _storeNameController,
                                          validator: (input) {
                                            if (input!.isEmpty)
                                              return 'Please enter a Store Name';
                                          },
                                          decoration: InputDecoration(
                                              focusedErrorBorder:
                                                  OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.red),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.red),
                                              ),
                                              errorStyle:
                                                  TextStyle(height: 0.4),
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 20.0),
                                              enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.grey)),
                                              focusColor: Colors.grey,
                                              focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                color: Colors.grey,
                                              )),
                                              labelText: "Enter Store Name",
                                              labelStyle:
                                                  TextStyle(color: Colors.grey),
                                              prefixIcon: Icon(Icons.store,
                                                  color: Colors.grey)),
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      ButtonTheme(
                                        buttonColor: Color(0xff2C6846),
                                        minWidth:
                                            MediaQuery.of(context).size.width *
                                                0.92,
                                        height: 55.0,
                                        child: RaisedButton(
                                          padding: EdgeInsets.fromLTRB(
                                              70, 10, 70, 10),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(5.0),
                                          ),
                                          onPressed: () async {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              await FirebaseFirestore.instance
                                                  .collection('MerchantData')
                                                  .doc(widget.currentUser?.uid)
                                                  .update({
                                                "storeName":
                                                    _storeNameController.text,
                                              }).then((value) => showFlash(
                                                        context: context,
                                                        duration:
                                                            const Duration(
                                                                seconds: 2),
                                                        builder: (context,
                                                            controller) {
                                                          return Flash.bar(
                                                            controller:
                                                                controller,
                                                            backgroundColor:
                                                                Colors.green,
                                                            position:
                                                                FlashPosition
                                                                    .top,
                                                            child: Container(
                                                                width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                                height: 70,
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Text(
                                                                      "Store Name Updated Successfully",
                                                                      style:
                                                                          const TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            18,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                )),
                                                          );
                                                        },
                                                      ));
                                              Future.delayed(
                                                  const Duration(seconds: 2),
                                                  () {});
                                              Navigator.of(context).pop();
                                            }
                                          },
                                          child: Text('Save',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600)),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 30,
                                      )
                                    ],
                                  ),
                                ));
                              });
                        },
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
                        onTap: () {
                          showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (BuildContext context) {
                                return SingleChildScrollView(
                                    child: Container(
                                  padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom,
                                    left: 20,
                                    right: 20,
                                    top: 10,
                                  ),
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        children: [
                                          Text(
                                            'Address',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Spacer(),
                                          IconButton(
                                            icon: const Icon(Icons.close),
                                            tooltip: 'Close',
                                            iconSize: 30,
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      Form(
                                        key: _formKey,
                                        child: TextFormField(
                                          controller: _storeAddressController,
                                          validator: (input) {
                                            if (input!.isEmpty)
                                              return 'Please enter Store Address';
                                          },
                                          maxLines: 4,
                                          decoration: InputDecoration(
                                              focusedErrorBorder:
                                                  OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.red),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.red),
                                              ),
                                              errorStyle:
                                                  TextStyle(height: 0.4),
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 20.0),
                                              enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.grey)),
                                              focusColor: Colors.grey,
                                              focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                color: Colors.grey,
                                              )),
                                              labelText: "Enter Store Address",
                                              labelStyle:
                                                  TextStyle(color: Colors.grey),
                                              prefixIcon: Icon(
                                                  Icons.location_on_outlined,
                                                  color: Colors.grey)),
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      ButtonTheme(
                                        buttonColor: Color(0xff2C6846),
                                        minWidth:
                                            MediaQuery.of(context).size.width *
                                                0.92,
                                        height: 55.0,
                                        child: RaisedButton(
                                          padding: EdgeInsets.fromLTRB(
                                              70, 10, 70, 10),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(5.0),
                                          ),
                                          onPressed: () async {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              //test
                                              var coordinates = await Geocoder
                                                  .local
                                                  .findAddressesFromQuery(
                                                      _storeAddressController
                                                          .text);
                                              latitude = coordinates
                                                  .first.coordinates.latitude;
                                              longitude = coordinates
                                                  .first.coordinates.longitude;
                                              await FirebaseFirestore.instance
                                                  .collection('MerchantData')
                                                  .doc(widget.currentUser?.uid)
                                                  .update({
                                                "storeAddress":
                                                    _storeAddressController
                                                        .text,
                                                "latitude": latitude,
                                                "longitude": longitude,
                                              }).then((value) => showFlash(
                                                        context: context,
                                                        duration:
                                                            const Duration(
                                                                seconds: 2),
                                                        builder: (context,
                                                            controller) {
                                                          return Flash.bar(
                                                            controller:
                                                                controller,
                                                            backgroundColor:
                                                                Colors.green,
                                                            position:
                                                                FlashPosition
                                                                    .top,
                                                            child: Container(
                                                                width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                                height: 70,
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Text(
                                                                      "Store Address Updated Successfully",
                                                                      style:
                                                                          const TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            18,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                )),
                                                          );
                                                        },
                                                      ));
                                              Future.delayed(
                                                  const Duration(seconds: 2),
                                                  () {});
                                              Navigator.of(context).pop();
                                            }
                                          },
                                          child: Text('Save',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600)),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 30,
                                      )
                                    ],
                                  ),
                                ));
                              });
                        },
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
