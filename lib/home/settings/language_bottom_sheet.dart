import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/app_colors.dart';
import 'package:todoapp/providers/app_config_provider.dart';

class LanguageBottomSheet extends StatefulWidget {
  const LanguageBottomSheet({Key? key}) : super(key: key);

  @override
  State<LanguageBottomSheet> createState() => _LanguageBottomSheetState();
}

class _LanguageBottomSheetState extends State<LanguageBottomSheet> {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfigProvider>(context);
    return Container(
      margin: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: InkWell(
                onTap: () {
                  provider.chanageLanguage('en');
                },
                child: provider.appLanguage == 'en'
                    ? getSelectedItemWidget(
                        AppLocalizations.of(context)!.english)
                    : getUnSelectedItemWidget(
                        AppLocalizations.of(context)!.english)),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: InkWell(
                onTap: () {
                  provider.chanageLanguage('ar');
                },
                child: provider.appLanguage == 'ar'
                    ? getSelectedItemWidget(
                        AppLocalizations.of(context)!.arabic)
                    : getUnSelectedItemWidget(
                        AppLocalizations.of(context)!.arabic)),
          ),
        ],
      ),
    );
  }

  Widget getSelectedItemWidget(String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(text,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: AppColors.primaryColor)),
        Icon(Icons.check, size: 30, color: AppColors.primaryColor)
      ],
    );
  }

  Widget getUnSelectedItemWidget(String text) {
    return Text(text, style: Theme.of(context).textTheme.bodySmall);
  }
}
