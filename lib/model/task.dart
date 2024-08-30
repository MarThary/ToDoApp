import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  String? id;
  String title;
  String description;
  DateTime dateTime;
  bool isDone;

  static const String collectionName = "tasks";

  Task(
      {this.id,
      required this.title,
      required this.description,
      required this.dateTime,
      this.isDone = false});

  factory Task.fromFireStror(Map<String, dynamic> data) {
    return Task(
      id: data['id'],
      title: data['title'],
      description: data['description'],
      dateTime: _parseDateTime(data['dateTime']),
      isDone: data['isDone'] ?? false,
    );
  }

  Map<String, dynamic> toFireStore() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dateTime': Timestamp.fromDate(dateTime),
      'isDone': isDone
    };
  }

  static DateTime _parseDateTime(dynamic dateTimeField) {
    if (dateTimeField is Timestamp) {
      return dateTimeField.toDate();
    } else if (dateTimeField is int) {
      return DateTime.fromMillisecondsSinceEpoch(dateTimeField);
    } else if (dateTimeField is DateTime) {
      return dateTimeField;
    } else {
      throw ArgumentError('Invalid dateTime type');
    }
  }
}
