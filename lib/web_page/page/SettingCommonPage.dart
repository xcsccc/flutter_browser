import 'package:browser01/web_page/color/colors.dart';
import 'package:browser01/web_page/custom/image_path.dart';
import 'package:browser01/web_page/dialog/long_click_dialog.dart';
import 'package:browser01/web_page/now_icon.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import '../../generated/l10n.dart';
import '../custom/custom.dart';
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
  late List<SettingCommonInfo> settingCommonInfoList =
      provider.settingCommonInfo;

  bool isFirst = true;

  @override
  Widget build(BuildContext context) {
    var names = S.of(context).userAgents.split(',');
    return SettingTopView([
      Expanded(
          child: Consumer<GlobalProvider>(builder: (context, notifier, child) {
        return ListView.builder(
            itemCount: settingCommonInfoList.length,
            itemBuilder: (context, index) {
              return SizedBox(
                width: double.infinity,
                child: InkWell(
                    customBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    onTap: () {
                      switch (index) {
                        case 0:
                          Navigator.of(context).pushNamed(
                              RouteSetting.userAgentSetting,
                              arguments: 6);
                          break;
                        default:
                          toastMsg(settingCommonInfoList[index].title);
                          break;
                      }
                    },
                    child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(settingCommonInfoList[index].title,
                                style: const TextStyle(fontSize: 15)),
                            if (settingCommonInfoList[index].desc != "")
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text(settingCommonInfoList[index].desc,
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: ThemeColors.descColor)),
                              )
                          ],
                        ))),
              );
            });
      }))
    ], "Common");
  }
}
