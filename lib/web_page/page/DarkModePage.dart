import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import '../../generated/l10n.dart';
import '../color/colors.dart';
import '../custom/custom.dart';
import '../main_view/view.dart';
import '../provider/main_provider.dart';

class DarkModePage extends StatefulWidget {
  const DarkModePage({super.key});

  @override
  State createState() {
    return DarkModeState();
  }
}

class DarkModeState extends State<DarkModePage> {
  var isSelect = Hive.box(boolKey).get(forceDarkKey, defaultValue: false);
  late var provider = Provider.of<GlobalProvider>(context);

  @override
  Widget build(BuildContext context) {
    return SettingTopView([
      SizedBox(
        width: double.infinity,
        child: InkWell(
          onTap: () {

          },
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Padding(
            padding:
                const EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 20),
            child: Text(S.of(context).maskFilter,
                style: const TextStyle(fontSize: 15)),
          ),
        ),
      ),
      Padding(
          padding:
              const EdgeInsets.only(left: 15, right: 10, top: 30, bottom: 15),
          child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Force dark operation for web content",
                        style: TextStyle(fontSize: 15)),
                    Text(
                        "When enabled,we pages will be forced to be dark,but exceptions may be displayed on certain pages",
                        style: TextStyle(
                            fontSize: 12,
                            color: provider.currentTheme == ThemeData.dark()
                                ? ThemeColors.descLightColor
                                : ThemeColors.descDarkColor))
                  ]),
            ),
            Checkbox(
                value: isSelect,
                onChanged: (value) {
                  setState(() {
                    isSelect = value;
                    provider.updateForceDark(isSelect);
                    Hive.box(boolKey).put(forceDarkKey, isSelect);
                  });
                },
                activeColor: ThemeColors.blueButtonColor)
          ]))
    ], S.of(context).night);
  }
}
