import 'package:cloud_firestore/cloud_firestore.dart';

Future<List<String>> getQuestionRecord(String email) async {
  List<String> questionRecordList = [];
  DateTime now = DateTime.now();
  print("${now.year}.${now.month}.${now.day}");

  CollectionReference ref =
      FirebaseFirestore.instance.collection("id/" + email + "/answer");

  QuerySnapshot<Object?> qs = await ref
      .where('date', isEqualTo: "${now.year}.${now.month}.${now.day}")
      .get();
  QueryDocumentSnapshot data = qs.docs[0];

  int i = 0;

  while (true) {
    try {
      questionRecordList.add(data["question ${i}"]);
    } catch (e) {
      break;
    }
    i++;
  }

  return questionRecordList;
}
