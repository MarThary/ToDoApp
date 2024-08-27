import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/home/task_list/task_list_item.dart';
import 'package:todoapp/providers/list_provider.dart';

import '../../providers/app_config_provider.dart';

class TaskListTab extends StatefulWidget {
  @override
  State<TaskListTab> createState() => _TaskListTabState();
}

class _TaskListTabState extends State<TaskListTab> {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfigProvider>(context);
    var listProvider = Provider.of<ListProvider>(context);
    if (listProvider.tasksList.isEmpty) {
      listProvider.getAllTasksFromFireStore();
    }
    return Container(
      child: Column(
        children: [
          EasyDateTimeLine(
            initialDate: DateTime.now(),
            onDateChange: (selectedDate) {
              listProvider.changeDate(selectedDate);
            },
            headerProps: EasyHeaderProps(
                monthPickerType: MonthPickerType.switcher,
                monthStyle: Theme.of(context).textTheme.bodySmall,
                dateFormatter: DateFormatter.fullDateDayAsStrMY(),
                selectedDateStyle: Theme.of(context).textTheme.bodySmall),
            dayProps: const EasyDayProps(
                dayStructure: DayStructure.dayStrDayNum,
                activeDayStyle: DayStyle(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xff3371FF),
                        Color(0xff8426D6),
                      ],
                    ),
                  ),
                ),
                inactiveDayStyle: DayStyle(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xff3371FF),
                        Color(0xff8426D6),
                      ],
                    ),
                  ),
                ),
                todayStyle: DayStyle(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xff083fbe),
                        Color(0xff9178a3),
                      ],
                    ),
                  ),
                )),
          ),
          Expanded(
            child: listProvider.tasksList.isEmpty
                ? Text(
                    AppLocalizations.of(context)!.no_tasks_added,
                    style: Theme.of(context).textTheme.bodyMedium,
                  )
                : ListView.builder(
                    itemBuilder: (context, index) {
                      return TaskListItem(task: listProvider.tasksList[index]);
                    },
                    itemCount: listProvider.tasksList.length,
                  ),
          )
        ],
      ),
    );
  }
}
