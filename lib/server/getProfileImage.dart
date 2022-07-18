import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';

Future<String> getProfileImage(String email) async {
  CollectionReference ref = FirebaseFirestore.instance.collection("id/");
  DocumentSnapshot documentSnapshot = await ref.doc(email).get();

  return documentSnapshot.get("proFileImageURL").toString();
}
