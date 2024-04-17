import 'package:browser01/web_page/color/colors.dart';
import 'package:browser01/web_page/custom/image_path.dart';
import 'package:browser01/web_page/now_icon.dart';
import 'package:flutter/material.dart';

import '../../generated/l10n.dart';

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
    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
            child: Column(children: [
          Row(
            children: [
              IconImageButton(
                res: AppImages.back,
                onClick: () {
                  Navigator.of(context).pop(null);
                },
                radius: 10,
              ),
              Text(S.of(context).setting,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16))
            ],
          ),
          Divider(height: 1, thickness: 1.2, color: ThemeColors.divideColor),
          Expanded(
              child: ListView.builder(
                  itemCount: settingList.length,
                  itemBuilder: (context, index) {
                    return settingItem(settingList[index], () {
                      Navigator.of(context).pop(null);
                    });
                  }))
        ])));
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
