import 'package:browser01/web_page/color/colors.dart';
import 'package:browser01/web_page/custom/image_path.dart';
import 'package:browser01/web_page/now_icon.dart';
import 'package:flutter/material.dart';

import '../../generated/l10n.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State createState() {
    return AboutState();
  }
}

class AboutState extends State<AboutPage> {
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
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Row(
                children: [
                  IconImageButton(
                    res: AppImages.back,
                    onClick: () {
                      Navigator.of(context).pop(null);
                    },
                    radius: 10,
                  ),
                  const Text("About",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16))
                ],
              )),
          Divider(height: 1, thickness: 1.2, color: ThemeColors.divideColor),
          Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Image.asset(
                  AppImages.aboutLogo,
                  height: 100,
                  fit: BoxFit.fitHeight,
                ),
              ),
              const Text("Z-time Browser",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text("1.0"),
              )
            ],
          )),
          const Padding(padding: EdgeInsets.only(top: 40)),
          SizedBox(
              width: double.infinity,
              child: InkWell(
                  onTap: () {},
                  customBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0), // 设置圆角半径为10.0
                  ),
                  child: const Padding(
                      padding: EdgeInsets.only(left: 15, top: 20, bottom: 20),
                      child: Text("Privacy policy",
                          style: TextStyle(fontSize: 15))))),
          SizedBox(
              width: double.infinity,
              child: InkWell(
                  onTap: () {},
                  customBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0), // 设置圆角半径为10.0
                  ),
                  child: const Padding(
                      padding: EdgeInsets.only(left: 15, top: 20, bottom: 20),
                      child: Text("Open source licenses",
                          style: TextStyle(fontSize: 15))))),
        ])));
  }
}