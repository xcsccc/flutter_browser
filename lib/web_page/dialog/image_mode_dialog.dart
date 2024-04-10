import 'dart:ffi';

import 'package:browser01/web_page/color/colors.dart';
import 'package:browser01/web_page/custom/custom.dart';
import 'package:browser01/web_page/dialog/long_click_dialog.dart';
import 'package:browser01/web_page/provider/main_provider.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import '../../generated/l10n.dart';

void showImageModeDialog(BuildContext context) {
  showDialog(context: context, builder: (context) {
    return const ImageModeDialog();
  });
}

class ImageModeDialog extends StatefulWidget {
  const ImageModeDialog({super.key});

  @override
  State<StatefulWidget> createState() => ImageModeState();
}

class ImageModeInfo {
  final ImageModeType type;
  String name;

  ImageModeInfo({required this.name, required this.type});
}

class ImageModeState extends State<ImageModeDialog> {
  late var provider = Provider.of<GlobalProvider>(context,listen: false);
  late List<ImageModeInfo> list = [];

  int selectValue = 0;

  @override
  Widget build(BuildContext context) {
    if (list.isEmpty) {
      var select = Hive.box(intKey).get(browserFlagKey, defaultValue: 0);
      var names = S
          .of(context)
          .imageModes
          .split(',');
      for (int index = 0; index < ImageModeType.values.length; index++) {
        list.add(ImageModeInfo(
            name: names[index], type: ImageModeType.values[index]));
      }
      selectValue = select;
    }
    return CustomBaseDialog(child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(S
            .of(context)
            .imageMode, style: const TextStyle(fontSize: 15,fontWeight: FontWeight.w500),textAlign: TextAlign.left,),
        const Divider(height: 10, color: Colors.transparent,),
        ListView.builder(itemCount: ImageModeType.values.length,
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              var item = list[index];
              return GestureDetector(
                onTap: (){
                  setState(() {
                    selectValue = index;
                    Hive.box(intKey).put(imageModeKey, index);
                    provider.updateImageMode(item.type);
                    Navigator.of(context).pop();
                  });
                },
                child: Row(
                  children: [
                    Radio(
                      value: index, groupValue: selectValue, onChanged: (value) {},activeColor: ThemeColors.progressStartColor,), Padding(padding: const EdgeInsets.only(left: 10),
                      child: Text(item.name,
                        style: TextStyle(fontSize: 13, color: index ==
                            selectValue ? ThemeColors.progressStartColor : Theme.of(context).textTheme.bodyMedium?.color ),),)
                  ],
                ),
              );
            })
      ],
    ));
  }

}