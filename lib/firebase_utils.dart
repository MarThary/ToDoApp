import 'package:cloud_firestore/cloud_firestore.dart';

import 'model/task.dart';

// withConverter --> make firebase know the data type of something will be stored
// const --> I can know the data type while Compile  Time
// final --> I can know the data type while Run Time

class FirebaseUtils {
  static CollectionReference<Task> getTaskCollection() {
    return FirebaseFirestore.instance
        .collection(Task.collectionName)
        .withConverter<Task>(
            fromFirestore: ((snapshot, options) =>
                Task.fromFireStror(snapshot.data()!)),
            toFirestore: (task, options) => task.toFireStore());
  }

  static Future<void> addTaskToFireStror(Task task) {
    var taskCollection = getTaskCollection(); // Collection
    var taskDocRef = taskCollection.doc(); // Document
    task.id = taskDocRef.id; // auto ID
    return taskDocRef.set(task);
  }

  static Future<void> deleteTaskFromFireStore(Task task) {
    return getTaskCollection().doc(task.id).delete();
  }

  static String getTaskID() {
    return getTaskCollection().doc().id;
  }

  static Future<void> editTaskFromFireStore(Task task) {
    return getTaskCollection().doc(task.id).update({
      'title': task.title,
      'description': task.description,
      'dateTime': task.dateTime
    });
  }

  static Future<void> updateTaskInFireStore(Task task) async {
    await getTaskCollection().doc(task.id).update({
      'isDone': task.isDone,
    });
  }
}
