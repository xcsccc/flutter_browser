import 'package:browser01/web_page/main_view/view.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import '../../generated/l10n.dart';
import '../color/colors.dart';
import '../custom/custom.dart';
import '../dialog/user_agent_dialog.dart';
import '../provider/main_provider.dart';

class UserAgentSettingPage extends StatefulWidget {
  const UserAgentSettingPage({super.key});

  @override
  State createState() {
    return UserAgentSettingPageState();
  }
}

class UserAgentSettingPageState extends State<UserAgentSettingPage> {
  late var provider = Provider.of<GlobalProvider>(context, listen: false);
  late List<UserAgentInfo> list = [];
  int selectValue = 0;

  @override
  Widget build(BuildContext context) {
    if (list.isEmpty) {
      var select = Hive.box(intKey).get(browserFlagKey, defaultValue: 0);
      var names = S.of(context).userAgents.split(',');
      for (int index = 0; index < UserAgentType.values.length; index++) {
        list.add(UserAgentInfo(
            name: names[index], type: UserAgentType.values[index]));
      }
      selectValue = select;
    }

    return SettingTopView([
      Expanded(
          child: ListView.builder(
              itemCount: UserAgentType.values.length,
              itemBuilder: (context, index) {
                var item = list[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectValue = index;
                      Hive.box(intKey).put(browserFlagKey, index);
                      provider.updateUserAgentSetting(item, 0);
                      Navigator.of(context).pop();
                    });
                  },
                  child: Container(
                      color: Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 3),
                        child: Row(
                          children: [
                            Radio(
                              value: index,
                              groupValue: selectValue,
                              onChanged: (value) {
                                setState(() {
                                  selectValue = index;
                                  Hive.box(intKey).put(browserFlagKey, index);
                                  provider.updateUserAgentSetting(item, 0);
                                  Navigator.of(context).pop();
                                });
                              },
                              activeColor: ThemeColors.progressStartColor,
                            ),
                            Text(
                              item.name,
                              style: TextStyle(
                                  fontSize: 13,
                                  color: index == selectValue
                                      ? ThemeColors.progressStartColor
                                      : Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.color),
                            ),
                          ],
                        ),
                      )),
                );
              }))
    ], "Browser User Agent");
  }
}
