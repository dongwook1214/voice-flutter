import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Future<List<String>> getQuestion(String id, String date) async {
  List<String> todayData = [];
  CollectionReference ref =
      FirebaseFirestore.instance.collection("id/" + id + "/question");

  QuerySnapshot querySnapshot = await ref.get();
  List allData = querySnapshot.docs.map((doc) => doc.data()).toList();

  for (int i = 0; i < allData.length; i++) {
    if (allData[i]["date"] == date) {
      int j = 1;
      while (allData[i][j.toString()] != null) {
        todayData.add(allData[i][j.toString()]);
        j++;
      }
      break;
    }
  }
  print(todayData);
  return todayData;
}
