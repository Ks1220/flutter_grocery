import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_grocery/AuthService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_grocery/HomePage.dart';
import 'package:image_picker/image_picker.dart';

import 'package:dotted_border/dotted_border.dart';

class AddItem extends StatefulWidget {
  const AddItem({Key? key}) : super(key: key);

  @override
  _AddItemState createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  final AuthService _auth = AuthService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  User? user = FirebaseAuth.instance.currentUser;
  File? image;

  TextEditingController _itemNameController = TextEditingController();
  TextEditingController _itemDescriptionController = TextEditingController();
  TextEditingController _itemStockController = TextEditingController();
  TextEditingController _itemPriceController = TextEditingController();
  TextEditingController _itemMeasurementController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      final imageTemporary = File(image.path);
      setState(() => this.image = imageTemporary);
    } on PlatformException catch (e) {
      print("Failed to pick image: $e");
    }
  }

  showError(BuildContext context, Object errormessage) {
    showFlash(
      context: context,
      duration: const Duration(seconds: 5),
      builder: (context, controller) {
        return Flash.bar(
          margin: const EdgeInsets.fromLTRB(1.0, 0.0, 1.0, 0.0),
          controller: controller,
          backgroundColor: Colors.red,
          position: FlashPosition.top,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(75.0, 20.0, 75.0, 20.0),
            child: Text(
              errormessage.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        );
      },
    );
  }

  showMyDialog() async {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Remove Image'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text(
                    'Are you sure to delete this image? Once delete, you will required to insert another image.'),
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
              onPressed: () {
                setState(() => this.image = null);
                Navigator.of(context).pop();
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
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      appBar: !isKeyboard
          ? AppBar(
              toolbarHeight: 65.0,
              backgroundColor: Color(0xff2C6846),
              title: const Text('Item Details'),
            )
          : null,
      body: Center(
          child: Column(
        children: <Widget>[
          SizedBox(height: 20),
          Container(
            width: mediaQueryData.size.width * 0.85,
            child: Form(
                key: _formKey,
                child: Column(children: [
                  TextFormField(
                    controller: _itemNameController,
                    validator: (input) {
                      if (input!.isEmpty) return 'Please enter an item name';
                    },
                    decoration: InputDecoration(
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      errorStyle: TextStyle(height: 0.4),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xff2C6846))),
                      focusColor: Color(0xff2C6846),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                        color: Color(0xff2C6846),
                      )),
                      labelStyle: TextStyle(color: Color(0xff2C6846)),
                      labelText: "Item Name",
                    ),
                  ),
                  SizedBox(height: 25),
                  image != null
                      ? Container(
                          child: Stack(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  DottedBorder(
                                    padding: EdgeInsets.all(10.0),
                                    color: Color(0xff2C6846),
                                    child: Image.file(image!,
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover),
                                    borderType: BorderType.RRect,
                                    radius: Radius.circular(5),
                                    dashPattern: [10, 5],
                                  ),
                                ],
                              ),
                              Align(
                                  alignment: Alignment.topLeft,
                                  child: CircleAvatar(
                                    radius: 10,
                                    backgroundColor: Colors.white,
                                    child: IconButton(
                                      padding: EdgeInsets.zero,
                                      alignment: Alignment.topLeft,
                                      icon: Icon(Icons.remove_circle),
                                      color: Colors.red,
                                      onPressed: () => {showMyDialog()},
                                    ),
                                  )),
                            ],
                          ),
                        )
                      : (SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 120,
                          child: DottedBorder(
                            color: Color(0xff2C6846),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                    flex: 1,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        RawMaterialButton(
                                          onPressed: () =>
                                              pickImage(ImageSource.gallery),
                                          elevation: 2.0,
                                          fillColor: Color(0xff2C6846),
                                          child: Icon(
                                            Icons.image,
                                            size: 35.0,
                                            color: Colors.white,
                                          ),
                                          padding: EdgeInsets.all(15.0),
                                          shape: CircleBorder(),
                                        ),
                                        SizedBox(height: 10.0),
                                        Text("Upload Image",
                                            style: TextStyle(
                                                color: Color(0xff2C6846)))
                                      ],
                                    )),
                                Text("or",
                                    style: TextStyle(color: Color(0xff2C6846))),
                                Expanded(
                                    flex: 1,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        RawMaterialButton(
                                          onPressed: () =>
                                              pickImage(ImageSource.camera),
                                          elevation: 2.0,
                                          fillColor: Colors.white,
                                          child: Icon(
                                            Icons.camera_alt,
                                            size: 35.0,
                                            color: Color(0xff2C6846),
                                          ),
                                          padding: EdgeInsets.all(15.0),
                                          shape: CircleBorder(),
                                        ),
                                        SizedBox(height: 10.0),
                                        Text("Take Photo",
                                            style: TextStyle(
                                                color: Color(0xff2C6846)))
                                      ],
                                    )),
                              ],
                            ),
                            borderType: BorderType.RRect,
                            radius: Radius.circular(5),
                            dashPattern: [10, 5],
                          ),
                        )),
                  SizedBox(height: 25),
                  TextField(
                    keyboardType: TextInputType.multiline,
                    minLines: 4,
                    maxLines: null,
                    controller: _itemDescriptionController,
                    decoration: InputDecoration(
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        errorStyle: TextStyle(height: 0.4),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff2C6846))),
                        focusColor: Color(0xff2C6846),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                          color: Color(0xff2C6846),
                        )),
                        labelStyle: TextStyle(color: Color(0xff2C6846)),
                        labelText: "Item Description",
                        hintText: "Enter details for this product"),
                  ),
                  SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          controller: _itemStockController,
                          validator: (input) {
                            if (input!.isEmpty)
                              return 'Pleas enter Stock Amount for this item';
                          },
                          decoration: InputDecoration(
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                            ),
                            errorStyle: TextStyle(height: 0.4),
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xff2C6846))),
                            focusColor: Color(0xff2C6846),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                              color: Color(0xff2C6846),
                            )),
                            labelStyle: TextStyle(color: Color(0xff2C6846)),
                            labelText: "Stock Amount",
                          ),
                        ),
                      ),
                      SizedBox(width: 10.0),
                      Expanded(
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          controller: _itemPriceController,
                          validator: (input) {
                            if (input!.isEmpty)
                              return 'Pleas enter the Price for this item';
                          },
                          decoration: InputDecoration(
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                            ),
                            errorStyle: TextStyle(height: 0.4),
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xff2C6846))),
                            focusColor: Color(0xff2C6846),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                              color: Color(0xff2C6846),
                            )),
                            labelStyle: TextStyle(color: Color(0xff2C6846)),
                            labelText: "Item Price",
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 25.0),
                  TextFormField(
                    controller: _itemMeasurementController,
                    validator: (input) {
                      if (input!.isEmpty)
                        return 'Pleas enter a Measurement Matrix for this item';
                    },
                    decoration: InputDecoration(
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      errorStyle: TextStyle(height: 0.4),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xff2C6846))),
                      focusColor: Color(0xff2C6846),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                        color: Color(0xff2C6846),
                      )),
                      labelStyle: TextStyle(color: Color(0xff2C6846)),
                      labelText: "Measure Matrix (e.g: kg, g, ml, l)",
                    ),
                  ),
                ])),
          ),
          SizedBox(height: 30),
          ButtonTheme(
            buttonColor: Color(0xff2C6846),
            minWidth: mediaQueryData.size.width * 0.85,
            height: 60.0,
            child: RaisedButton(
              padding: EdgeInsets.fromLTRB(70, 10, 70, 10),
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(5.0),
              ),
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection('Items')
                    .doc(user!.uid)
                    .collection('Item')
                    .doc()
                    .set({
                  "itemName": _itemNameController.text,
                  "itemImage": image!.path,
                  "itemDescription": _itemDescriptionController.text,
                  "stockAmount": _itemStockController.text,
                  "price": _itemPriceController.text,
                  "measurementMatrix": _itemMeasurementController.text
                });
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => HomePage()));
              },
              child: Text('Save',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      )),
    );
  }
}
