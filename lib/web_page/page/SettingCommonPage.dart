import 'package:browser01/web_page/color/colors.dart';
import 'package:browser01/web_page/custom/image_path.dart';
import 'package:browser01/web_page/dialog/long_click_dialog.dart';
import 'package:browser01/web_page/now_icon.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import '../../generated/l10n.dart';
import '../custom/custom.dart';
import '../model/setting_common_info.dart';
import '../provider/main_provider.dart';

class SettingCommonPage extends StatefulWidget {
  const SettingCommonPage({super.key});

  @override
  State createState() {
    return SettingCommonState();
  }
}

class SettingCommonState extends State<SettingCommonPage> {
  var userAgentIndex = Hive.box(intKey).get(browserFlagKey, defaultValue: 0);
  late var provider = Provider.of<GlobalProvider>(context, listen: false);
  late List<SettingCommonInfo> settingCommonInit;
  late List<SettingCommonInfo> settingCommonInfoList;
  bool isFirst = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (isFirst) {
      isFirst = false;
      settingCommonInit = [
        SettingCommonInfo(title: "Browser User Agent", desc: "Default"),
        SettingCommonInfo(title: "Clear Data", desc: ""),
        SettingCommonInfo(title: "Dark Mode", desc: ""),
        SettingCommonInfo(title: "Auto Hide Action Bar", desc: "Disabled"),
        SettingCommonInfo(title: "Custom Menu", desc: ""),
        SettingCommonInfo(title: "Home", desc: "Default"),
        SettingCommonInfo(title: "Search Engine", desc: "Baidu"),
        SettingCommonInfo(title: "Search Suggestions", desc: ""),
        SettingCommonInfo(
            title: "DownLoad Manager", desc: "Built in Downloader"),
        SettingCommonInfo(title: "Address Bar Content", desc: "TITLE"),
        SettingCommonInfo(title: "Clear Data On Exit", desc: ""),
        SettingCommonInfo(title: "Set Default In Browser", desc: "")
      ];
      settingCommonInfoList =
          provider.getSettingCommonInfoList(settingCommonInit).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    var names = S.of(context).userAgents.split(',');

    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                  const Text("Common",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16))
                ],
              )),
          Divider(height: 1, thickness: 1.2, color: ThemeColors.divideColor),
          Expanded(
              child: ListView.builder(
                  itemCount: settingCommonInfoList.length,
                  itemBuilder: (context, index) {
                    return SizedBox(
                      width: double.infinity,
                      child: InkWell(
                          customBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          onTap: () {
                            toastMsg(settingCommonInfoList[index].title);
                          },
                          child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 15, top: 20, bottom: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(settingCommonInfoList[index].title,
                                      style: const TextStyle(fontSize: 15)),
                                  if (settingCommonInfoList[index].desc != "")
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5),
                                      child: Text(
                                          settingCommonInfoList[index].desc,
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: ThemeColors.descColor)),
                                    )
                                ],
                              ))),
                    );
                  })),
        ])));
  }
}
