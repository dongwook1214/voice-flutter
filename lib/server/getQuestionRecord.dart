import 'package:cloud_firestore/cloud_firestore.dart';

Future<Map<String, String>> getQuestionRecord(String email) async {
  Map<String, String> questionRecordMap = {};
  DateTime now = DateTime.now();
  print("${now.year}.${now.month}.${now.day}");

  CollectionReference ref =
      FirebaseFirestore.instance.collection("id/" + email + "/answer");

  QuerySnapshot<Object?> qs =
      await ref.where('date', isEqualTo: '2022.7.15').get();
  QueryDocumentSnapshot data = qs.docs[0];

  int i = 0;

  while (true) {
    try {
      questionRecordMap["question ${i}"] = data["question ${i}"];
    } catch (e) {
      break;
    }
    i++;
  }

  return questionRecordMap;
}
