import 'package:cloud_firestore/cloud_firestore.dart';

Future<List> getAllDialogue(String email) async {
  List allDialogue = [];
  CollectionReference ref =
      FirebaseFirestore.instance.collection("id/" + email + "/answer");

  QuerySnapshot querySnapshot = await ref.get();
  allDialogue = querySnapshot.docs.map((doc) => doc.data()).toList();

  return allDialogue;
}
