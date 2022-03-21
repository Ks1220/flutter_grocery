import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flash/flash.dart';
import 'dart:developer';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
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
              width: MediaQuery.of(context).size.width,
              height: 70,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    errormessage.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ],
              )),
        );
      },
    );
  }

  //Login
  Future loginUser(BuildContext context, String email, String password) async {
    FirebaseUser user;
    String errorMessage;
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email.toString(), password: password.toString());
      return result.user;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "ERROR_EMAIL_ALREADY_IN_USE":
        case "account-exists-with-different-credential":
        case "email-already-in-use":
          showError(context, "Email already used. Go to login page.");
          break;
        case "ERROR_WRONG_PASSWORD":
        case "wrong-password":
          showError(context, "Wrong email/password combination.");
          break;
        case "ERROR_USER_NOT_FOUND":
        case "user-not-found":
          showError(context, "No user found with this email.");
          break;
        case "ERROR_USER_DISABLED":
        case "user-disabled":
          showError(context, "User disabled.");
          break;
        case "ERROR_TOO_MANY_REQUESTS":
        case "operation-not-allowed":
          showError(context, "Too many requests to log into this account.");
          break;
        case "ERROR_OPERATION_NOT_ALLOWED":
        case "operation-not-allowed":
          showError(context, "Server error, please try again later.");
          break;
        case "ERROR_INVALID_EMAIL":
        case "invalid-email":
          showError(context, "Email address is invalid.");
          break;
        default:
          showError(context, "Login failed. Please try again.");
          break;
      }
    }
  }
}

mixin FirebaseUser {}
