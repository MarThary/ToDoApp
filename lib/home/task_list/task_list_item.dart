import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/app_colors.dart';
import 'package:todoapp/firebase_utils.dart';
import 'package:todoapp/home/task_list/edit_task_sheet.dart';
import 'package:todoapp/providers/app_config_provider.dart';

import '../../model/task.dart';
import '../../providers/list_provider.dart';

// ignore: must_be_immutable
class TaskListItem extends StatefulWidget {
  Task task;

  TaskListItem({super.key, required this.task});

  @override
  State<TaskListItem> createState() => _TaskListItemState();
}

class _TaskListItemState extends State<TaskListItem> {
  var listProvider;

  @override
  Widget build(BuildContext context) {
    listProvider = Provider.of<ListProvider>(context);
    var provider = Provider.of<AppConfigProvider>(context);
    return Container(
      margin: const EdgeInsets.all(12.0),
      child: Slidable(
        startActionPane: ActionPane(
          extentRatio: 0.27,
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              borderRadius: BorderRadius.circular(15),
              onPressed: (context) {
                FirebaseUtils.deleteTaskFromFireStore(widget.task).timeout(
                    const Duration(
                      seconds: 1,
                    ), onTimeout: () {
                  listProvider.getAllTasksFromFireStore();
                });
                const snackdemoEn = SnackBar(
                  content: Text('Task Deleted Successfully'),
                  backgroundColor: AppColors.primaryColor,
                  elevation: 10,
                  behavior: SnackBarBehavior.floating,
                  margin: EdgeInsets.all(40),
                );
                const snackdemoAr = SnackBar(
                  content: Text('تم حذف المهمة بنجاح'),
                  backgroundColor: AppColors.primaryColor,
                  elevation: 30,
                  behavior: SnackBarBehavior.floating,
                  margin: EdgeInsets.all(50),
                );
                provider.appLanguage == 'en'
                    ? ScaffoldMessenger.of(context).showSnackBar(snackdemoEn)
                    : ScaffoldMessenger.of(context).showSnackBar(snackdemoAr);
              },
              backgroundColor: AppColors.redColor,
              foregroundColor: AppColors.whiteColor,
              icon: Icons.delete,
              label: AppLocalizations.of(context)!.delete,
            ),
          ],
        ),
        endActionPane: ActionPane(
          extentRatio: 0.25,
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              borderRadius: BorderRadius.circular(15),
              flex: 2,
              onPressed: (context) {
                if (widget.task.isDone == true) {
                  showDialog(
                      context: context,
                      builder: provider.isDarkMode()
                          ? (ctx) => AlertDialog(
                                  backgroundColor:
                                      AppColors.backgroundDarkColor,
                                  content: provider.appLanguage == 'en'
                                      ? const Text(
                                          "You can not edit task ,Task is already done .")
                                      : const Text(
                                          "لا يمكنك تغيير المهمة، المهمة قد تمت بالفعل ."),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(ctx).pop();
                                      },
                                      child: Container(
                                        color: AppColors.primaryColor,
                                        padding: const EdgeInsets.all(14),
                                        child: provider.appLanguage == 'en'
                                            ? const Text("Ok",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold))
                                            : const Text("حسنا",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                      ),
                                    ),
                                  ])
                          : (ctx) => AlertDialog(
                                  content: const Text(
                                      "You can not edit task ,Task is already done ."),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(ctx).pop();
                                      },
                                      child: Container(
                                        color: AppColors.primaryColor,
                                        padding: const EdgeInsets.all(14),
                                        child: const Text("Ok",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    ),
                                  ]));
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditTaskSheet(task: widget.task),
                    ),
                  );
                }
              },
              backgroundColor: const Color(0xFF7BC043),
              foregroundColor: Colors.white,
              icon: Icons.edit,
              label: AppLocalizations.of(context)!.edit,
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: provider.isDarkMode()
                ? AppColors.blackDarkColor
                : AppColors.whiteColor,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  margin: const EdgeInsets.all(15),
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: 4,
                  color: widget.task.isDone
                      ? AppColors.greenColor
                      : AppColors.primaryColor),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.task.title,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: widget.task.isDone
                            ? AppColors.greenColor
                            : AppColors.primaryColor),
                  ),
                  Text(
                    widget.task.description,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: AppColors.primaryColor),
                  ),
                ],
              )),
              TextButton(
                onPressed: () {
                  setState(() {
                    widget.task.isDone = true;
                  });
                  FirebaseUtils.updateTaskInFireStore(widget.task).then((_) {
                    listProvider.getAllTasksFromFireStore();
                  }).catchError((error) {
                    print("Failed to update task: $error");
                  });
                },
                child: widget.task.isDone
                    ? Text(
                        'Done!',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(color: AppColors.greenColor),
                      )
                    : const Icon(
                        Icons.check,
                        size: 35,
                        color: AppColors.primaryColor,
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
