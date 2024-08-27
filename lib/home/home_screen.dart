import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:todoapp/app_colors.dart';
import 'package:todoapp/home/settings/settings_tab.dart';
import 'package:todoapp/home/task_list/add_task_bottom_sheet.dart';
import 'package:todoapp/home/task_list/task_list_tab.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "home_screen";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    String? set = AppLocalizations.of(context)!.settings;
    String? task = AppLocalizations.of(context)!.task_list;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height * 0.18,
        title: Text(
          selectedIndex == 0
              ? AppLocalizations.of(context)!.app_title
              : AppLocalizations.of(context)!.settings,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        centerTitle: false,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          selectedIndex = index;
          setState(() {});
        },
        items: [
          BottomNavigationBarItem(
              icon: ImageIcon(
                AssetImage('assets/images/icon_list.png'),
              ),
              label: task),
          BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('assets/images/icon_settings.png')),
              label: set),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddTaskBottomSheet();
        },
        child: Icon(
          Icons.add,
          size: 40,
          color: AppColors.whiteColor,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: selectedIndex == 0 ? TaskListTab() : SettingsTab(),
    );
  }

  void showAddTaskBottomSheet() {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: AppColors.primaryColor, width: 2)),
        context: context,
        builder: (context) => AddTaskBottomSheet());
  }
}
