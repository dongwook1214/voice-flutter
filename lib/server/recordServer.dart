import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

Future<void> uploadRecordFileAndrodid(
    String path, String email, String date, String fieldName) async {
  String _audioID = const Uuid().v4();
  final storageRef = FirebaseStorage.instance.ref("audio/" + _audioID);
  await storageRef.putFile(
    File(path),
    SettableMetadata(
      contentType: "audio/mp4",
    ),
  );

  String link = await _downloadURLExample("audio/" + _audioID);

  CollectionReference users =
      FirebaseFirestore.instance.collection("id/${email}/answer");

  try {
    await users.doc(date).update({fieldName: link});
  } catch (e) {
    await users.doc(date).set({"date": date, fieldName: link});
  }
  print("${link} ${fieldName} success");
}

Future<void> uploadRecordFileWeb(
    Uint8List bytesData, String email, String date, String fieldName) async {
  String audioID = const Uuid().v4();
  final storageRef = FirebaseStorage.instance.ref("audio/" + audioID);
  await storageRef.putData(
    bytesData,
    SettableMetadata(
      contentType: "audio/mp4",
    ),
  );
  String link = await _downloadURLExample("audio/" + audioID);
  CollectionReference users =
      FirebaseFirestore.instance.collection("id/${email}/answer");

  try {
    await users.doc(date).update({fieldName: link});
  } catch (e) {
    await users.doc(date).set({fieldName: link});
  }
}

Future<String> _downloadURLExample(String filePath) async {
  String downloadURL =
      await FirebaseStorage.instance.ref(filePath).getDownloadURL();

  return downloadURL;
}
