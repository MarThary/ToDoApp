/*
  class Task{
  static const String collectionName = "tasks";
  String id ;
  String title ;
  String description ;
  DateTime dateTime ;
  bool isDone ;

  Task({this.id = '',required this.title ,required this.description,
  required this.dateTime ,this.isDone = false});

// (json => object) Read From Firebase
  Task.fromFireStror (Map <String,dynamic> data) : this(
    // Custing
    id:data['id'] ,
    title:data['title'] ,
    description: data['description'],
    dateTime:DateTime.fromMillisecondsSinceEpoch(data['dateTime'])  ,
    isDone:data['isDone'] ,
  );

  // (object => josn) Write to Firebase
  Map<String,dynamic> toFireStore() {
    return {
      'id' : id,
      'title' : title,
      'description' : description,
      // millisecondsSinceEpoch to deal with int
      'dateTime' : dateTime.millisecondsSinceEpoch,
      'isDone' : isDone
    };
  }
}
 */
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

  // Factory constructor to create a Task from Firestore data
  factory Task.fromFireStror(Map<String, dynamic> data) {
    return Task(
      id: data['id'],
      title: data['title'],
      description: data['description'],
      dateTime: _parseDateTime(data['dateTime']),
      // Handle dateTime conversion
      isDone: data['isDone'] ?? false,
    );
  }

  // Method to convert a Task to a Firestore-compatible format
  Map<String, dynamic> toFireStore() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dateTime': Timestamp.fromDate(dateTime), // Convert DateTime to Timestamp
      'isDone': isDone
    };
  }

  // Helper function to handle different types of dateTime inputs
  static DateTime _parseDateTime(dynamic dateTimeField) {
    if (dateTimeField is Timestamp) {
      return dateTimeField.toDate(); // Handle Firestore Timestamp
    } else if (dateTimeField is int) {
      return DateTime.fromMillisecondsSinceEpoch(
          dateTimeField); // Handle int as epoch time
    } else if (dateTimeField is DateTime) {
      return dateTimeField; // Already a DateTime object
    } else {
      throw ArgumentError('Invalid dateTime type'); // Handle unexpected types
    }
  }
}
