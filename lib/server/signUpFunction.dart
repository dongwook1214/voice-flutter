import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;

void signUpWithEmail(
    String email, String password, XFile? image, String name, context) async {
  try {
    _showSnackBar(context, "계정이 잘 생성됐습니다!");
    Navigator.pop(context);
    var result = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    if (result.user != null) {
      result.user!.sendEmailVerification();
    }
    _setProfile(image, email, name);
  } on Exception catch (e) {
    print(e);
    _showSnackBar(context, e.toString());
  }
}

Future<void> _setProfile(XFile? image, String email, String name) async {
  String _fileID = const Uuid().v4();
  Reference ref = FirebaseStorage.instance.ref('proFileImage/' + _fileID);
  if (image == null) {
    await ref.putData(
      (await rootBundle.load("asset/images/basicProfile.jpeg"))
          .buffer
          .asUint8List(),
      SettableMetadata(
        contentType: "image/jpeg",
      ),
    );
  } else {
    kIsWeb
        ? await ref.putData(
            await image.readAsBytes(),
            SettableMetadata(
              contentType: "image/jpeg",
            ),
          )
        : await ref.putFile(
            File(image.path),
            SettableMetadata(
              contentType: "image/jpeg",
            ),
          );
  }

  String _fileURL = await _downloadURLExample('proFileImage/' + _fileID);

  CollectionReference users = FirebaseFirestore.instance.collection("id/");
  users.doc(email).set({'name': name, 'proFileImageURL': _fileURL});
}

Future<String> _downloadURLExample(String filePath) async {
  String downloadURL =
      await FirebaseStorage.instance.ref(filePath).getDownloadURL();

  return downloadURL;
}

void _showSnackBar(context, String message) {
  final snackBar = SnackBar(content: Text(message));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
