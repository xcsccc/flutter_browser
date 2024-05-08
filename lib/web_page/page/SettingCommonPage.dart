import 'package:browser01/web_page/color/colors.dart';
import 'package:browser01/web_page/custom/image_path.dart';
import 'package:browser01/web_page/dialog/clear_data_dialog.dart';
import 'package:browser01/web_page/dialog/long_click_dialog.dart';
import 'package:browser01/web_page/now_icon.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import '../../generated/l10n.dart';
import '../custom/custom.dart';
import '../dialog/search_engine_dialog.dart';
import '../main_view/view.dart';
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
  late List<SettingCommonInfo> settingCommonInfoList = provider.settingCommonInfo;

  bool isFirst = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (isFirst) {
      isFirst = false;
      var settingCommonInit = [
        SettingCommonInfo(title: "Browser User Agent", desc: "Android(Phone)"),
        SettingCommonInfo(title: "Clear Data", desc: ""),
        SettingCommonInfo(title: "Dark Mode", desc: ""),
        SettingCommonInfo(title: "Auto Hide Action Bar", desc: "Disabled"),
        SettingCommonInfo(title: "Custom Menu", desc: ""),
        SettingCommonInfo(title: "Home", desc: "Default"),
        SettingCommonInfo(title: "Search Engine", desc: "Baidu"),
        SettingCommonInfo(title: "Search Suggestions", desc: ""),
        SettingCommonInfo(title: "DownLoad Manager", desc: "Built in Downloader"),
        SettingCommonInfo(title: "Address Bar Content", desc: "TITLE"),
        SettingCommonInfo(title: "Clear Data On Exit", desc: ""),
        SettingCommonInfo(title: "Set Default In Browser", desc: "")
      ];
      settingCommonInfoList = provider.getSettingCommonInfoList(settingCommonInit).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    var names = S.of(context).userAgents.split(',');
    return SettingTopView([
      Expanded(child: Consumer<GlobalProvider>(builder: (context, notifier, child) {
        return ListView.builder(
            itemCount: settingCommonInfoList.length,
            itemBuilder: (context, index) {
              var item = settingCommonInfoList[index];
              return SizedBox(
                width: double.infinity,
                child: InkWell(
                    customBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    onTap: () {
                      switch (index) {
                        case 0:
                          Navigator.of(context).pushNamed(RouteSetting.userAgentSetting, arguments: 6);
                          break;
                        case 1:
                          showClearDialog(context);
                          break;
                        case 2:
                          Navigator.of(context).pushNamed(RouteSetting.darkMode, arguments: 7);
                          break;
                        case 6:
                          showSearchEngineDialog(context);
                          break;
                        default:
                          toastMsg(item.title);
                          break;
                      }
                    },
                    child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.title, style: const TextStyle(fontSize: 15)),
                            if (item.desc != "")
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text(item.desc,
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: provider.currentTheme == ThemeData.dark()
                                            ? ThemeColors.descLightColor
                                            : ThemeColors.descDarkColor)),
                              )
                          ],
                        ))),
              );
            });
      }))
    ], "Common");
  }
}
