import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Future<List> getQuestion(String id, String date) async {
  List<String> list = [];
  CollectionReference ref =
      FirebaseFirestore.instance.collection("id/" + id + "/question");

  DocumentSnapshot documentSnapshot = await ref.doc(date).get();
  var data = await documentSnapshot.data();

  print(data);

  return list;
}
