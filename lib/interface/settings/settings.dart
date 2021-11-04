// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:harmonoid/constants/language.dart';

import 'package:harmonoid/interface/settings/accent.dart';
import 'package:harmonoid/interface/settings/about.dart';
import 'package:harmonoid/interface/settings/indexing.dart';
import 'package:harmonoid/interface/settings/language.dart';
import 'package:harmonoid/interface/settings/miscellaneous.dart';
import 'package:harmonoid/interface/settings/theme.dart';
import 'package:harmonoid/interface/settings/version.dart';
import 'package:harmonoid/utils/widgets.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 56.0,
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white.withOpacity(0.10)
                : Colors.black.withOpacity(0.10),
            border: Border(
              bottom: BorderSide(
                  color: Theme.of(context).dividerColor.withOpacity(0.12)),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              NavigatorPopButton(),
              SizedBox(
                width: 24.0,
              ),
              Text(
                language!.STRING_SETTING,
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 16.0,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: CustomListView(
            shrinkWrap: true,
            children: [
              SizedBox(
                height: 4.0,
              ),
              AboutSetting(),
              IndexingSetting(),
              ThemeSetting(),
              AccentSetting(),
              // LanguageSetting(),
              MiscellaneousSetting(),
              VersionSetting(),
              SizedBox(
                height: 4.0,
              ),
            ],
          ),
        ),
      ],
    ));
  }
}

class SettingsTile extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final Widget child;
  final EdgeInsets? margin;
  final List<Widget>? actions;

  const SettingsTile({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.child,
    this.actions,
    this.margin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 4.0,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8.0),
        border:
            Border.all(color: Theme.of(context).dividerColor.withOpacity(0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              top: 16.0,
              left: 16.0,
              right: 16.0,
              bottom: 8.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  this.title!,
                  style: Theme.of(context).textTheme.headline2,
                ),
                Divider(color: Colors.transparent, height: 4.0),
                Text(
                  this.subtitle!,
                  style: Theme.of(context).textTheme.headline3,
                ),
                Divider(color: Colors.transparent, height: 8.0),
                Divider(
                  color: Theme.of(context).dividerColor,
                  thickness: 1.0,
                  height: 1.0,
                ),
              ],
            ),
          ),
          Container(
            margin: this.margin ?? EdgeInsets.zero,
            child: this.child,
          ),
          Divider(color: Colors.transparent, height: 8.0),
          if (this.actions != null) ...[
            Divider(
              color: Theme.of(context).dividerColor,
              thickness: 1.0,
              indent: 16.0,
              endIndent: 16.0,
              height: 1.0,
            ),
            ButtonBar(
              alignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
              children: this.actions!,
            ),
          ],
        ],
      ),
    );
  }
}
