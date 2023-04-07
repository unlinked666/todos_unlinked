import 'package:cloud_firestore/cloud_firestore.dart';

class TodoClass {
  final String title;
  final String description;
  final DateTime dateTime;

  TodoClass({
    required this.title,
    required this.description,
    required this.dateTime,
  });

  factory TodoClass.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data();

    return TodoClass(
      title: data?["title"],
      description: data?["description"],
      dateTime: data?['dateTime'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "title": title,
      "description": description,
      "dateTime": dateTime,
    };
  }
}
