import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../src/home.dart';

Future loginFunction(id, password, context) async {
  try {
    final UserCredential result = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: id, password: password);
    final user = result.user;

    if (user == null) {
      return;
    }
    _onLoginSuccess(context, id);
  } on FirebaseAuthException catch (e) {
    print(e);
    if (e.code == 'user-not-found') {
      _showSnackBar(context, "올바른 아이디를 입력하세요.");
      print("user-not-found");
    } else if (e.code == 'wrong-password') {
      _showSnackBar(context, "올바른 비밀번호를 입력하세요.");
      print('wrong-password');
    } else if (e.code == 'invalid-email') {
      _showSnackBar(context, "올바른 아이디 형식을 입력하세요.");
      print('invalid-email');
    } else if (e.code == 'unknown') {
      _showSnackBar(context, "아이디와 비밀번호를 적어주세요.");
      print('unknown');
    }
  }
}

void _onLoginSuccess(context, id) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('id', id);
  Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => homePage(id: id)),
      (route) => false);
}

void _showSnackBar(context, String message) {
  final snackBar = SnackBar(content: Text(message));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
