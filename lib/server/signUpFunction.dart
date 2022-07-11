import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void signUpWithEmail(String email, String password, context) async {
  try {
    var result = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    if (result.user != null) {
      result.user!.sendEmailVerification();
    }
    Navigator.pop(context);
    _showSnackBar(context, "계정이 잘 생성됐습니다!");
  } on Exception catch (e) {
    print(e);
    _showSnackBar(context, e.toString());
  }
}

void _showSnackBar(context, String message) {
  final snackBar = SnackBar(content: Text(message));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
