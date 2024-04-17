import 'package:browser01/web_page/color/colors.dart';
import 'package:browser01/web_page/custom/custom.dart';
import 'package:browser01/web_page/dialog/long_click_dialog.dart';
import 'package:browser01/web_page/provider/main_provider.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import '../../generated/l10n.dart';

void showUserAgentDialog(BuildContext context) {
  showDialog(context: context, builder: (context) {
    return const UserAgentDialog();
  });
}

class UserAgentDialog extends StatefulWidget {
  const UserAgentDialog({super.key});

  @override
  State<StatefulWidget> createState() => UserAgentState();

}

class UserAgentInfo {
  final UserAgentType type;
  String name;

  UserAgentInfo({required this.name, required this.type});
}

class UserAgentState extends State<UserAgentDialog> {
  late var provider = Provider.of<GlobalProvider>(context,listen: false);
  late List<UserAgentInfo> list = [];

  int selectValue = 0;

  @override
  Widget build(BuildContext context) {
    if (list.isEmpty) {
      var select = Hive.box(intKey).get(browserFlagKey, defaultValue: 0);
      var names = S
          .of(context)
          .userAgents
          .split(',');
      for (int index = 0; index < UserAgentType.values.length; index++) {
        list.add(UserAgentInfo(
            name: names[index], type: UserAgentType.values[index]));
      }
      selectValue = select;
    }
    return CustomBaseDialog(child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(S
            .of(context)
            .browserFlag, style: const TextStyle(fontSize: 15,fontWeight: FontWeight.w500),textAlign: TextAlign.left,),
        const Divider(height: 10, color: Colors.transparent,),
        ListView.builder(itemCount: UserAgentType.values.length,
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              var item = list[index];
              return GestureDetector(
                onTap: (){
                  setState(() {
                    selectValue = index;
                    Hive.box(intKey).put(browserFlagKey, index);
                    provider.updateUserAgent(item.type);
                    Navigator.of(context).pop();
                  });
                },
                child: Container(color: Colors.transparent,child: Row(
                  children: [
                    Radio(
                      value: index, groupValue: selectValue, onChanged: (value) {
                      setState(() {
                        selectValue = index;
                        Hive.box(intKey).put(browserFlagKey, index);
                        provider.updateUserAgent(item.type);
                        Navigator.of(context).pop();
                      });
                    },activeColor: ThemeColors.progressStartColor,), Padding(padding: const EdgeInsets.only(left: 10),
                      child: Text(item.name,
                        style: TextStyle(fontSize: 13, color: index ==
                            selectValue ? ThemeColors.progressStartColor : Theme.of(context).textTheme.bodyMedium?.color ),),)
                  ],
                )),
              );
            })
      ],
    ));
  }

}