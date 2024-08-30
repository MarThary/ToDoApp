import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/app_colors.dart';
import 'package:todoapp/home/settings/language_bottom_sheet.dart';
import 'package:todoapp/home/settings/theme_bottom_sheet.dart';
import 'package:todoapp/providers/app_config_provider.dart';

class SettingsTab extends StatefulWidget {
  const SettingsTab({super.key});

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var provider = Provider.of<AppConfigProvider>(context);
    return Container(
      margin: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppLocalizations.of(context)!.language,
              style: Theme.of(context).textTheme.bodyMedium),
          SizedBox(height: height * 0.02),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: provider.isDarkMode()
                    ? AppColors.backgroundDarkColor
                    : AppColors.whiteColor,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: AppColors.primaryColor, width: 2)),
            child: InkWell(
              onTap: () {
                showLanguageButtomSheet();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      provider.appLanguage == 'en'
                          ? AppLocalizations.of(context)!.english
                          : AppLocalizations.of(context)!.arabic,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(color: AppColors.primaryColor)),
                  Icon(
                    Icons.arrow_drop_down,
                    color: provider.isDarkMode()
                        ? AppColors.whiteColor
                        : AppColors.primaryColor,
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: height * 0.03,
          ),
          Text(AppLocalizations.of(context)!.mode,
              style: Theme.of(context).textTheme.bodyMedium),
          SizedBox(height: height * 0.02),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: provider.isDarkMode()
                    ? AppColors.backgroundDarkColor
                    : AppColors.whiteColor,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: AppColors.primaryColor, width: 2)),
            child: InkWell(
              onTap: () {
                showThemeBottomSheet();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      provider.isDarkMode()
                          ? AppLocalizations.of(context)!.dark
                          : AppLocalizations.of(context)!.light,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(color: AppColors.primaryColor)),
                  Icon(Icons.arrow_drop_down,
                      color: provider.isDarkMode()
                          ? AppColors.whiteColor
                          : AppColors.primaryColor)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showLanguageButtomSheet() {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: AppColors.primaryColor, width: 2)),
        context: context,
        builder: (context) => const LanguageBottomSheet());
  }

  void showThemeBottomSheet() {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: AppColors.primaryColor, width: 2)),
        context: context,
        builder: (context) => const ThemeBottomSheet());
  }
}
