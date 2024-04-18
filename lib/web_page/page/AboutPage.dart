import 'package:browser01/web_page/color/colors.dart';
import 'package:browser01/web_page/custom/image_path.dart';
import 'package:browser01/web_page/main_view/view.dart';
import 'package:browser01/web_page/now_icon.dart';
import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../custom/custom.dart';

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
    return SettingTopView([
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
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: const Padding(
                  padding: EdgeInsets.only(left: 15, top: 20, bottom: 20),
                  child: Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Text("Privacy policy",
                          style: TextStyle(fontSize: 15)))))),
      SizedBox(
          width: double.infinity,
          child: InkWell(
              onTap: () {
                Navigator.of(context)
                    .pushNamed(RouteSetting.openSource, arguments: 4);
              },
              customBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: const Padding(
                  padding: EdgeInsets.only(left: 15, top: 20, bottom: 20),
                  child: Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Text("Open source licenses",
                          style: TextStyle(fontSize: 15))))))
    ], "About");
  }
}
