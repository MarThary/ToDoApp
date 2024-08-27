import 'package:flutter/cupertino.dart';
import 'package:todoapp/model/task.dart';

import '../firebase_utils.dart';

class ListProvider extends ChangeNotifier {
  List<Task> tasksList = [];

  var selectDate = DateTime.now();

  void getAllTasksFromFireStore() async {
    // get all tasks
    var querySnapshot = await FirebaseUtils.getTaskCollection().get();
    tasksList = querySnapshot.docs.map((doc) {
      return doc.data();
    }).toList();
    // filter tasks => select date (user)
    tasksList = tasksList.where((task) {
      if (selectDate.day == task.dateTime.day &&
          selectDate.month == task.dateTime.month &&
          selectDate.year == task.dateTime.year) {
        return true;
      }
      return false;
    }).toList();
    // Sorting Tasks
    tasksList.sort((task1, task2) {
      return task1.dateTime.compareTo(task2.dateTime);
    });

    notifyListeners();
  }

  void changeDate(DateTime newDate) {
    selectDate = newDate;
    getAllTasksFromFireStore();
  }
}
