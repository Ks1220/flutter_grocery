// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grocery/AuthService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_grocery/Verify.dart';
// import 'package:flutter_grocery/provider/GoogleSignInProvider.dart';
// import 'package:flutter_signin_button/flutter_signin_button.dart';
// import 'package:provider/provider.dart';

class StoreDetails extends StatefulWidget {
  final TextEditingController _nameController,
      _emailController,
      _passwordController,
      _confirmPasswordController;
  StoreDetails(this._nameController, this._emailController,
      this._passwordController, this._confirmPasswordController,
      {Key? key})
      : super(key: key);
  _StoreDetailsState createState() => _StoreDetailsState();
}

class _StoreDetailsState extends State<StoreDetails> {
  final AuthService _auth = AuthService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  TextEditingController _storeNameController = TextEditingController();
  TextEditingController _storeAddressOneController = TextEditingController();
  TextEditingController _storeAddressTwoController = TextEditingController();
  TextEditingController _storePostalCodeController = TextEditingController();
  TextEditingController _storeCityController = TextEditingController();
  TextEditingController _storeStateController = TextEditingController();
  TextEditingController _storeCountryController = TextEditingController();

  late String _email, _password, _name, _confirmpass;

  @override
  void initState() {
    super.initState();
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

  bool _isObscure2 = true;

  @override
  Widget build(BuildContext context) {
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      appBar: !isKeyboard
          ? AppBar(
              titleSpacing: 12,
              leading: ModalRoute.of(context)?.canPop == true
                  ? IconButton(
                      splashColor: Colors.transparent,
                      padding: const EdgeInsets.only(left: 30.0, bottom: 15.0),
                      icon: Icon(
                        Icons.arrow_back,
                        size: 35,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      color: Colors.black,
                    )
                  : null,
              title: Image.asset('images/logo-name.png'),
              backgroundColor: new Color(0xffff),
              shadowColor: Colors.transparent,
              elevation: 0,
              toolbarHeight: 90.0,
            )
          : null,
      body: Center(
          child: Column(
        children: <Widget>[
          if (!isKeyboard) SizedBox(height: 10.0),
          if (!isKeyboard)
            Container(
              child: RichText(
                textAlign: TextAlign.left,
                text: TextSpan(
                    text: "Shop Details",
                    style: TextStyle(
                        fontSize: 26,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        color: Colors.black)),
              ),
              width: mediaQueryData.size.width * 0.85,
            ),
          if (!isKeyboard)
            Container(
              child: RichText(
                textAlign: TextAlign.left,
                text: TextSpan(
                    text:
                        "Please enter your shop details before proceed on adding your grocery items ",
                    style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        color: Colors.black)),
              ),
              width: mediaQueryData.size.width * 0.85,
            ),
          SizedBox(height: 30),
          Container(
            width: mediaQueryData.size.width * 0.85,
            child: Form(
                key: _formKey,
                child: Column(children: [
                  TextFormField(
                    controller: _storeNameController,
                    validator: (input) {
                      if (input!.isEmpty) return 'Please enter a Shop Name';
                    },
                    decoration: InputDecoration(
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        errorStyle: TextStyle(height: 0.4),
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 20.0),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff2C6846))),
                        focusColor: Color(0xff2C6846),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                          color: Color(0xff2C6846),
                        )),
                        labelStyle: TextStyle(color: Color(0xff2C6846)),
                        labelText: "Shop Name",
                        prefixIcon:
                            Icon(Icons.store, color: Color(0xff2C6846))),
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    controller: _storeAddressOneController,
                    validator: (input) {
                      if (input!.isEmpty) return 'Pleas enter an address';
                    },
                    decoration: InputDecoration(
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        errorStyle: TextStyle(height: 0.4),
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 20.0),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff2C6846))),
                        focusColor: Color(0xff2C6846),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                          color: Color(0xff2C6846),
                        )),
                        labelStyle: TextStyle(color: Color(0xff2C6846)),
                        labelText: "Address 1",
                        prefixIcon: Icon(Icons.location_on_outlined,
                            color: Color(0xff2C6846))),
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    controller: _storeAddressTwoController,
                    validator: (input) {
                      if (input!.length < 5)
                        return 'Please enter an appropriate address';
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
                      labelText: "Address 2",
                    ),
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: TextFormField(
                          controller: _storePostalCodeController,
                          validator: (input) {
                            if (input!.length < 5)
                              return 'Incorrect postal code';
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
                            labelText: "Postal Code",
                          ),
                        ),
                      ),
                      SizedBox(width: 10.0),
                      Expanded(
                        child: TextFormField(
                          controller: _storeStateController,
                          validator: (input) {
                            if (input!.length < 2) return 'No such state';
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
                            labelText: "State",
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    controller: _storeCountryController,
                    validator: (input) {
                      if (input!.length < 2)
                        return 'Please enter a correct country';
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
                      labelText: "Country",
                    ),
                  ),
                ])),
          ),
          SizedBox(height: 20),
          if (!isKeyboard)
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
                    var user;
                    try {
                      user = await _firebaseAuth.createUserWithEmailAndPassword(
                          email: widget._emailController.text,
                          password: widget._passwordController.text);
                    } on FirebaseAuthException catch (error) {
                      switch (error.code) {
                        case "email-already-in-use":
                          showError(context,
                              "The email entered previously was already in used. Please go to login page.");
                          break;
                      }
                    }
                    FirebaseFirestore.instance
                        .collection('MerchantData')
                        .doc(user.user!.uid)
                        .set({
                      "uid": _firebaseAuth.currentUser!.uid.toString(),
                      "email": user.user!.email,
                      "name": widget._nameController.text,
                      "storeName": _storeNameController.text,
                      "storeAddress": _storeAddressOneController.text +
                          "," +
                          _storeAddressTwoController.text +
                          _storePostalCodeController.text +
                          _storeCityController.text +
                          "," +
                          _storeStateController.text +
                          "," +
                          _storeCountryController.text,
                      "isMerchant": true
                    });
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => Verify()));
                  }
                },
                child: Text('Sign Up',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600)),
              ),
            ),
          SizedBox(height: 10.0),
          if (!isKeyboard)
            Container(
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    text:
                        "By signing up, you agree to our Terms of Service and Privacy Policy",
                    style: TextStyle(
                        fontSize: 11,
                        fontFamily: 'Roboto',
                        color: Colors.black)),
              ),
              width: 300,
            ),
          // SignInButton(
          //       Buttons.Google,
          //       onPressed: () {
          //         // final provider =
          //         //     Provider.of<GoogleSignInProvider>(context, listen: false);
          //         // provider.login();
          //       },
          //     )
        ],
      )),
    );
  }
}
