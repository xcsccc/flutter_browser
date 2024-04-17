import 'package:browser01/web_page/custom/custom.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../color/colors.dart';
import '../custom/image_path.dart';
import '../now_icon.dart';

class OpenSourcePage extends StatefulWidget {
  const OpenSourcePage({super.key});

  @override
  State createState() {
    return OpenSourceState();
  }
}

class OpenSourceState extends State<OpenSourcePage> {
  @override
  Widget build(BuildContext context) {
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
                  const Text("Open Source license",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16))
                ],
              )),
          Divider(height: 1, thickness: 1.2, color: ThemeColors.divideColor),
          Expanded(
            flex: 1,
              child: ListView.builder(
                  itemCount: sourceList.length,
                  itemBuilder: (context, index) {
                    return openSourceItem(sourceList[index]);
                  }))
        ])));
  }
}

Widget openSourceItem(String title) {
  return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
        Text(title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const Text("Apache License 2.0",
            style: TextStyle(fontSize: 13, color: Colors.grey))
      ]));
}
