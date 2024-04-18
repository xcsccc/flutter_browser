import 'package:browser01/web_page/color/colors.dart';
import 'package:browser01/web_page/custom/image_path.dart';
import 'package:browser01/web_page/main_view/view.dart';
import 'package:browser01/web_page/now_icon.dart';
import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../custom/custom.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State createState() {
    return SettingState();
  }
}

class SettingState extends State<SettingPage> {
  List<String> settingList = [
    'Common',
    'Custom',
    'Privacy',
    'Advanced',
    'Script',
    'About'
  ];

  @override
  Widget build(BuildContext context) {
    return SettingTopView([
      Expanded(
          child: ListView.builder(
              itemCount: settingList.length,
              itemBuilder: (context, index) {
                return settingItem(settingList[index], () {
                  switch (index) {
                    case 0:
                      Navigator.of(context)
                          .pushNamed(RouteSetting.settingsCommon, arguments: 5);
                      break;
                    case 5:
                      Navigator.of(context)
                          .pushNamed(RouteSetting.aboutPage, arguments: 3);
                      break;
                    default:
                      Navigator.of(context).pop(null);
                      break;
                  }
                });
              }))
    ], S.of(context).setting);
  }
}

Widget settingItem(String title, VoidCallback onTap) {
  return InkWell(
    onTap: onTap,
    customBorder: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20.0), // 设置圆角半径为10.0
    ),
    child: Padding(
        padding: const EdgeInsets.all(5),
        child: ListTile(
          title: Text(title),
        )),
  );
}
