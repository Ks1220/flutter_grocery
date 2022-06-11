import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_grocery/AuthService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_grocery/HomePage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;

import 'package:dotted_border/dotted_border.dart';

class AddItem extends StatefulWidget {
  final bool _isEdit;
  final String _itemId;

  const AddItem(this._isEdit, this._itemId, {Key? key}) : super(key: key);

  @override
  _AddItemState createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  final AuthService _auth = AuthService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  User? user = FirebaseAuth.instance.currentUser;
  File? _imageFile;
  late String imageUrl;
  DocumentSnapshot? groceryItem;

  String dropdownvalue = 'kg';

  var measurementMatrix = [
    'kg',
    'g',
    'mg',
    'L',
    'mL',
    'lb',
    'piece',
  ];

  TextEditingController _itemNameController = TextEditingController();
  TextEditingController _itemDescriptionController = TextEditingController();
  TextEditingController _itemStockController = TextEditingController();
  TextEditingController _itemPriceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchItemId();
  }

  fetchItemId() async {
    DocumentReference itemId = FirebaseFirestore.instance
        .collection('Items')
        .doc(user!.uid)
        .collection('Item')
        .doc(widget._itemId);
    if (widget._isEdit) {
      await itemId.get().then((docs) {
        setState(() {
          _itemNameController.text = docs["itemName"];
          _imageFile = File(docs["itemImage"]);
          imageUrl = docs["itemImage"];
          _itemDescriptionController.text = docs["itemDescription"];
          _itemStockController.text = docs["stockAmount"];
          _itemPriceController.text = docs["price"];
          dropdownvalue = docs["measurementMatrix"];
        });
      });
    }
  }

  Future pickImage(ImageSource source) async {
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
      });
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
          controller: controller,
          backgroundColor: Colors.red,
          position: FlashPosition.top,
          child: Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              height: 70,
              child: Text(
                errormessage.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              )),
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
                setState(() => _imageFile = null);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  showDeleteItemsDialog() async {
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
                    'Are you sure to delete this item? Once deleted, data of this item will be no longer available.'),
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
                await FirebaseFirestore.instance
                    .collection('Items')
                    .doc(user!.uid)
                    .collection('Item')
                    .doc(widget._itemId)
                    .delete();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => HomePage()));
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 65.0,
        iconTheme: IconThemeData(
          color: Color(0xff2C6846), //change your color here
        ),
        title:
            const Text('Item Details', style: TextStyle(color: Colors.black)),
        elevation: 0,
        backgroundColor: Colors.white,
        actions: <Widget>[
          (widget._isEdit == true
              ? MaterialButton(
                  onPressed: () => {showDeleteItemsDialog()},
                  child: Row(children: <Widget>[
                    Icon(Icons.delete_forever, size: 25, color: Colors.red),
                    Center(
                        child: Padding(
                      padding: EdgeInsets.fromLTRB(5, 0, 3, 0),
                      child: Text("Delete Forever",
                          style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.w700,
                              fontSize: 15),
                          textAlign: TextAlign.center),
                    ))
                  ]),
                )
              : Container())
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
            child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 5),
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
                    _imageFile != null
                        ? Container(
                            child: Stack(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    DottedBorder(
                                      padding: EdgeInsets.all(10.0),
                                      color: Color(0xff2C6846),
                                      child: (widget._isEdit == true
                                          ? Image.network(imageUrl,
                                              width: 100,
                                              height: 100,
                                              fit: BoxFit.cover)
                                          : Image.file(_imageFile!,
                                              width: 100,
                                              height: 100,
                                              fit: BoxFit.cover)),
                                      borderType: BorderType.RRect,
                                      radius: Radius.circular(5),
                                      dashPattern: [10, 5],
                                    ),
                                  ],
                                ),
                                (widget._isEdit == false
                                    ? Align(
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
                                        ))
                                    : Container())
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
                                            onPressed: () => {
                                              pickImage(ImageSource.gallery),
                                            },
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
                                      style:
                                          TextStyle(color: Color(0xff2C6846))),
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
                    (widget._isEdit == true
                        ? Container(
                            margin: const EdgeInsets.fromLTRB(0, 8.0, 0, 0),
                            child: Text(
                                "* Changing image feature is yet to be available, stay tune!",
                                style: TextStyle(
                                    fontSize: 14.0, color: Colors.red)))
                        : Container()),
                    SizedBox(height: 25),
                    TextFormField(
                      keyboardType: TextInputType.multiline,
                      minLines: 4,
                      maxLines: null,
                      controller: _itemDescriptionController,
                      validator: (input) {
                        if (input!.isEmpty)
                          return 'Description is required for every items';
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
                          labelText: "Item Description",
                          hintText: "Enter details for this product"),
                    ),
                    SizedBox(height: 25),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            controller: _itemStockController,
                            validator: (input) {
                              if (input!.isEmpty)
                                return 'Stock Amount required';
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
                              if (input!.isEmpty) return 'Item Price required';
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
                              labelText: "Item Price (RM)",
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 25.0),
                    DropdownButtonFormField(
                      value: dropdownvalue,
                      validator: (input) {
                        if (input.toString().isEmpty)
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
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: measurementMatrix.map((items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(items),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownvalue = newValue!;
                        });
                      },
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
                  if (_formKey.currentState!.validate()) {
                    if (widget._isEdit == true) {
                      await FirebaseFirestore.instance
                          .collection('Items')
                          .doc(user!.uid)
                          .collection('Item')
                          .doc(widget._itemId)
                          .update({
                        "itemName": _itemNameController.text,
                        "itemDescription": _itemDescriptionController.text,
                        "stockAmount": _itemStockController.text,
                        "price": _itemPriceController.text,
                        "measurementMatrix": dropdownvalue
                      }).then((value) => showFlash(
                                context: context,
                                duration: const Duration(seconds: 2),
                                builder: (context, controller) {
                                  return Flash.bar(
                                    controller: controller,
                                    backgroundColor: Colors.green,
                                    position: FlashPosition.top,
                                    child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 70,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Edited Successfully",
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                              ),
                                            ),
                                          ],
                                        )),
                                  );
                                },
                              ));
                      Future.delayed(const Duration(seconds: 2), () {});
                    } else {
                      await FirebaseFirestore.instance
                          .collection('Items')
                          .doc(user!.uid)
                          .collection('Item')
                          .doc()
                          .set({
                        "itemName": _itemNameController.text,
                        "itemImage": imageUrl,
                        "itemDescription": _itemDescriptionController.text,
                        "stockAmount": _itemStockController.text,
                        "price": double.parse(_itemPriceController.text)
                            .toStringAsFixed(2),
                        "measurementMatrix": dropdownvalue
                      }).then((value) => showFlash(
                                context: context,
                                duration: const Duration(seconds: 2),
                                builder: (context, controller) {
                                  return Flash.bar(
                                    controller: controller,
                                    backgroundColor: Colors.green,
                                    position: FlashPosition.top,
                                    child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 70,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Added Successfully",
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                              ),
                                            ),
                                          ],
                                        )),
                                  );
                                },
                              ));
                      _itemNameController.clear();
                      _itemDescriptionController.clear();
                      _itemStockController.clear();
                      _itemPriceController.clear();
                      Future.delayed(const Duration(seconds: 2), () {});
                    }

                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => HomePage()),
                        (Route<dynamic> route) => false);
                  }
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
      ),
    );
  }
}
