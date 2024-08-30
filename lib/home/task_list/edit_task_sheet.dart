import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/app_colors.dart';
import 'package:todoapp/firebase_utils.dart';

import '../../model/task.dart';
import '../../providers/app_config_provider.dart';
import '../../providers/list_provider.dart';

class EditTaskSheet extends StatefulWidget {
  static const String routeName = 'edit_task_sheet';
  final Task task;

  const EditTaskSheet({super.key, required this.task});

  @override
  State<EditTaskSheet> createState() => _EditTaskSheetState();
}

class _EditTaskSheetState extends State<EditTaskSheet> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late DateTime selectDate;
  var listProvider;

  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.task.title);
    descriptionController =
        TextEditingController(text: widget.task.description);
    selectDate = widget.task.dateTime;
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfigProvider>(context);
    listProvider = Provider.of<ListProvider>(context);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height * 0.18,
        title: Text(
          AppLocalizations.of(context)!.app_title,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        centerTitle: false,
      ),
      body: Stack(
        children: [
          Container(
            color: provider.isDarkMode()
                ? AppColors.backgroundDarkColor
                : AppColors.backgroundLightColor,
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.02),
              padding: const EdgeInsets.all(16.0),
              width: MediaQuery.of(context).size.width * 0.85,
              decoration: BoxDecoration(
                color: provider.isDarkMode()
                    ? AppColors.blackDarkColor
                    : AppColors.whiteColor,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Text(
                        AppLocalizations.of(context)!.edit_task,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    TextFormField(
                      controller: titleController,
                      style: Theme.of(context).textTheme.bodyMedium,
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return AppLocalizations.of(context)!
                              .please_enter_title;
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          labelText:
                              AppLocalizations.of(context)!.this_is_title,
                          labelStyle: Theme.of(context).textTheme.titleMedium),
                    ),
                    const SizedBox(height: 20.0),
                    TextFormField(
                      controller: descriptionController,
                      style: Theme.of(context).textTheme.bodyMedium,
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return AppLocalizations.of(context)!
                              .please_enter_description;
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.task_details,
                          labelStyle: Theme.of(context).textTheme.titleMedium),
                    ),
                    const SizedBox(height: 20.0),
                    Text(
                      AppLocalizations.of(context)!.select_time,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 20.0),
                    InkWell(
                      onTap: () {
                        showCalender();
                      },
                      child: Text(
                          '${selectDate.day}-${selectDate.month}-${selectDate.year}',
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(color: Colors.grey)),
                    ),
                    const SizedBox(height: 100.0),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState?.validate() == true) {
                            editTask();
                            Navigator.pop(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        child: Text(AppLocalizations.of(context)!.save_changes,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(color: AppColors.whiteColor)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showCalender() async {
    var chosenDate = await showDatePicker(
        context: context,
        initialDate: selectDate,
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 365)));
    if (chosenDate != null) {
      setState(() {
        selectDate = chosenDate;
      });
    }
  }
  void editTask() {
    Task task = Task(
      id: widget.task.id,
      title: titleController.text,
      description: descriptionController.text,
      dateTime: selectDate,
    );
    FirebaseUtils.editTaskFromFireStore(task)
        .timeout(const Duration(seconds: 1), onTimeout: () {
      listProvider.getAllTasksFromFireStore();
    });
  }
}
