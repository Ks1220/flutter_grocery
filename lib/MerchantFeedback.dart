import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;

import 'ForgotPassword.dart';
import 'Start.dart';

class MerchantFeedback extends StatefulWidget {
  const MerchantFeedback({Key? key}) : super(key: key);

  @override
  _MerchantFeedbackState createState() => _MerchantFeedbackState();
}

class _MerchantFeedbackState extends State<MerchantFeedback> {
  double rating = 1.0;
  TextEditingController _feedbackController = TextEditingController();
  User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 65.0,
        iconTheme: IconThemeData(
          color: Color(0xff2C6846), //change your color here
        ),
        title: const Text('Feedback', style: TextStyle(color: Colors.black)),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 15),
            RatingBar.builder(
              initialRating: 1,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemSize: 55,
              itemPadding: EdgeInsets.symmetric(horizontal: 5.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (r) {
                rating = r;
                print("THIS IS RATING: $rating");
              },
            ),
            SizedBox(height: 15),
            Container(
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    text:
                        "Tell us a bit more where we can improve in our application",
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        color: Colors.black)),
              ),
              width: MediaQuery.of(context).size.width * 0.78,
            ),
            Container(
              margin: EdgeInsets.fromLTRB(25, 20, 25, 0),
              child: TextField(
                minLines: 15,
                maxLines: null,
                controller: _feedbackController,
                decoration: InputDecoration(
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xff2C6846))),
                  focusColor: Color(0xff2C6846),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                    color: Color(0xff2C6846),
                  )),
                  labelStyle: TextStyle(color: Color(0xff2C6846)),
                  labelText: "Enter Feedback",
                ),
              ),
            ),
            SizedBox(height: 15.0),
            ButtonTheme(
              buttonColor: Color(0xff2C6846),
              minWidth: MediaQuery.of(context).size.width * 0.88,
              height: 55.0,
              child: RaisedButton(
                padding: EdgeInsets.fromLTRB(75, 10, 75, 10),
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(5.0),
                ),
                onPressed: () async {
                  await FirebaseFirestore.instance
                      .collection('MerchantRating')
                      .doc(currentUser?.uid)
                      .set({
                    "rating": rating,
                    "feedback": _feedbackController.text,
                  }).then((value) => showFlash(
                            context: context,
                            duration: const Duration(seconds: 2),
                            builder: (context, controller) {
                              return Flash.bar(
                                controller: controller,
                                backgroundColor: Colors.green,
                                position: FlashPosition.top,
                                child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 70,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Thank you for the feedback!",
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
                  Navigator.of(context).pop();
                },
                child: Text('Submit',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
