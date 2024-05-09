import 'dart:ffi';
import 'dart:io';

import 'package:browser01/web_page/custom/custom.dart';
import 'package:browser01/web_page/model/clear_data_exit_info.dart';
import 'package:browser01/web_page/model/history_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../../generated/l10n.dart';
import '../color/colors.dart';
import '../provider/main_provider.dart';
import 'long_click_dialog.dart';

void showClearExitDialog(BuildContext context) {
  var list = ClearDataType.values.toList();
  showDialog(
      context: context,
      builder: (context) {
        return const ClearDataExitDialog();
      });
}

class ClearDataExitDialog extends StatefulWidget {
  const ClearDataExitDialog({super.key});

  @override
  State<StatefulWidget> createState() => ClearDataExitState();
}

class ClearDataInfo {
  final ClearDataType type;
  String name;
  bool isSelect;

  ClearDataInfo({required this.name, required this.type, required this.isSelect});
}

class ClearDataExitState extends State<ClearDataExitDialog> {
  late var provider = Provider.of<GlobalProvider>(context);
  late List<ClearDataExitInfo> list = provider.clearDataExitInfo;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (list.isEmpty) {
      List<ClearDataExitInfo> initList = [];
      var names = S
          .of(context)
          .clearMode
          .split(',');
      for (int index = 0; index < ClearDataType.values.length; index++) {
        initList.add(ClearDataExitInfo(
            name: names[index],
            clearName: ClearDataType.values[index].clearName,
            isSelect: false));
      }
      list = provider.getClearDataExitInfoList(initList).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    var control = provider.getNowControl();
    return Dialog(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        child: Container(
            decoration: BoxDecoration(
                color: Theme
                    .of(context)
                    .brightness == Brightness.light
                    ? Colors.white
                    : ThemeColors.iconColorDark,
                border: Border.all(
                    color: Theme
                        .of(context)
                        .brightness == Brightness.light
                        ? ThemeColors.iconColorLight
                        : ThemeColors.iconColorDark,
                    width: 1),
                borderRadius: const BorderRadius.all(Radius.circular(20))),
            child: Padding(
              padding: const EdgeInsets.only(right: 15, top: 15, bottom: 15),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15, top: 10),
                      child: Text(S
                          .of(context)
                          .clear,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500)),
                    ),
                    ListView.builder(
                        itemCount: list.length,
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          var item = list[index];
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                item.isSelect = !item.isSelect;
                              });
                            },
                            child: Container(
                                color: Colors.transparent,
                                child: Padding(
                                  padding:
                                  const EdgeInsets.only(top: 6, bottom: 6),
                                  child: Row(
                                    children: [
                                      Radio(
                                        value: index,
                                        groupValue: item.isSelect ? index : 10,
                                        onChanged: (value) {
                                          setState(() {
                                            item.isSelect = !item.isSelect;
                                          });
                                        },
                                        activeColor:
                                        ThemeColors.blueButtonColor,
                                      ),
                                      Text(
                                        item.name,
                                        style: const TextStyle(fontSize: 15),
                                      ),
                                    ],
                                  ),
                                )),
                          );
                        }),
                    Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Text("Cancel",
                                  style: TextStyle(
                                      color: ThemeColors.blueButtonColor,
                                      fontSize: 17)),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              provider.updateClearDataExit(list);
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              "Sure",
                              style: TextStyle(
                                  color: ThemeColors.blueButtonColor,
                                  fontSize: 17),
                            ),
                          )
                        ],
                      ),
                    )
                  ]),
            )));
  }
}
