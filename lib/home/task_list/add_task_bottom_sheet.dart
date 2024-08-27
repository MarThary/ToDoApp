import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/app_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:todoapp/firebase_utils.dart';
import '../../model/task.dart';
import '../../providers/list_provider.dart';

class AddTaskBottomSheet extends StatefulWidget {
  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  String title = "";
  String des = "";
  var selectDate = DateTime.now();

  var formKey = GlobalKey<FormState>();
  late ListProvider listProvider;

  @override
  Widget build(BuildContext context) {
    listProvider = Provider.of<ListProvider>(context);
    return Container(
      margin: EdgeInsets.all(12),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              textAlign: TextAlign.center,
              AppLocalizations.of(context)!.add_new_task,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      style: Theme.of(context).textTheme.bodyMedium,
                      onChanged: (text) {
                        title = text;
                      },
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return AppLocalizations.of(context)!
                              .please_enter_title;
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          labelText:
                              AppLocalizations.of(context)!.enter_task_title,
                          labelStyle: Theme.of(context).textTheme.titleMedium),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      style: Theme.of(context).textTheme.bodyMedium,
                      onChanged: (text) {
                        des = text;
                      },
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          // Invalid
                          return AppLocalizations.of(context)!
                              .please_enter_description;
                        }
                        // Vaild
                        return null;
                      },
                      decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!
                              .enter_task_description,
                          labelStyle: Theme.of(context).textTheme.titleMedium),
                      maxLines: 4,
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(AppLocalizations.of(context)!.select_date,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith())),
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                          onTap: () {
                            showCalender();
                          },
                          child: Text(
                              '${selectDate.day}/${selectDate.month}/${selectDate.year}',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodySmall))),
                  ElevatedButton(
                      onPressed: () {
                        addTask();
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            AppColors.primaryColor),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.add,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void addTask() {
    Task task = Task(title: title, description: des, dateTime: selectDate);
    if (formKey.currentState?.validate() == true) {
      // return of addTaskToFireStror (Future<void>) so don't need to put await & async
      FirebaseUtils.addTaskToFireStror(task).timeout(Duration(seconds: 1),
          onTimeout: () {
        print('Task Added Succesfully');
        listProvider.getAllTasksFromFireStore();
        Navigator.pop(context);
      });
    }
  }

  void showCalender() async {
    // return of addTaskToFireStror (Future<DateTime?>) so we need to put await & async
    var chosenDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        // The available days is 1 year from date today
        lastDate: DateTime.now().add(Duration(days: 365)));
    if (chosenDate != null) {
      selectDate = chosenDate;
      setState(() {});
    }
    // OR Anthor soultion  ( Because 'selectDate' must HAS value CAN NOT be null )
    // selectDate = chosenDate ?? selectDate ;
  }
}
