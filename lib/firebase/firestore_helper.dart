import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_unlinked/data_helper/todo_class_helper.dart';

final FirebaseFirestore db = FirebaseFirestore.instance;

class TodosHelper {
  // Read Data
  static Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
      readData() async {
    var docs;
    try {
      await db.collection("todos").orderBy("dateTime").get().then((value) {
        docs = value.docs;
      });
    } catch (e) {
      docs = [];
    }

    return docs;
  }

  // Add Data
  static Future addData({required TodoClass todo}) async {
    await db
        .collection("todos")
        .withConverter(
            fromFirestore: TodoClass.fromFirestore,
            toFirestore: (TodoClass todoClass, options) => todo.toFirestore())
        .doc()
        .set(todo);
  }

  // Delete Data
  static Future deleteData({required String collection, String? doc}) async {
    await db.collection(collection).get().then((value) {
      for (DocumentSnapshot i in value.docs) {
        i.reference.delete();
      }
    });

    await db.collection("todos").doc().delete();
  }
}
