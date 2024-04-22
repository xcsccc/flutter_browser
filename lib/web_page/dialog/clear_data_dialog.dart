import 'dart:ffi';
import 'dart:io';

import 'package:browser01/web_page/custom/custom.dart';
import 'package:browser01/web_page/model/history_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../../generated/l10n.dart';
import '../color/colors.dart';
import '../provider/main_provider.dart';
import 'long_click_dialog.dart';

void showClearDialog(BuildContext context) {
  var list = ClearDataType.values.toList();
  showDialog(
      context: context,
      builder: (context) {
        return const ClearDataDialog();
      });
}

class ClearDataDialog extends StatefulWidget {
  const ClearDataDialog({super.key});

  @override
  State<StatefulWidget> createState() => ClearDataState();
}

class ClearDataInfo {
  final ClearDataType type;
  String name;
  bool isSelect;

  ClearDataInfo(
      {required this.name, required this.type, required this.isSelect});
}

class ClearDataState extends State<ClearDataDialog> {
  late List<ClearDataInfo> list = [];
  late var provider = Provider.of<GlobalProvider>(context);

  @override
  Widget build(BuildContext context) {
    var control = provider.getNowControl();
    if (list.isEmpty) {
      var names = S.of(context).clearMode.split(',');
      for (int index = 0; index < ClearDataType.values.length; index++) {
        list.add(ClearDataInfo(
            name: names[index],
            type: ClearDataType.values[index],
            isSelect: index == 0 || index == 1 || index == 2));
      }
    }

    return Dialog(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        child: Container(
            decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.white
                    : ThemeColors.iconColorDark,
                border: Border.all(
                    color: Theme.of(context).brightness == Brightness.light
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
                      child: Text(S.of(context).clear,
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
                                          groupValue:
                                              item.isSelect ? index : 10,
                                          onChanged: (value) {
                                            setState(() {
                                              item.isSelect = !item.isSelect;
                                            });
                                          }),
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
                            onTap: () async {
                              for (var element in list) {
                                if (element.isSelect) {
                                  switch (element.type) {
                                    case ClearDataType.form:
                                      control?.clearFormData();
                                      break;
                                    case ClearDataType.history:
                                      HistoryInfo.openBox().clear();
                                      control?.clearHistory();
                                      break;
                                    case ClearDataType.webStorage:
                                      InAppWebViewController.clearAllCache();
                                      CookieManager.instance()
                                          .deleteAllCookies();
                                      break;
                                    case ClearDataType.cookie:
                                      CookieManager.instance()
                                          .deleteAllCookies();
                                      break;
                                    case ClearDataType.appCache:
                                      Directory appCacheDir =
                                          await getTemporaryDirectory();
                                      String appCachePath = appCacheDir.path;
                                      try {
                                        await Directory(appCachePath)
                                            .delete(recursive: true);
                                        print('App cache cleared.');
                                      } catch (e) {
                                        print('Failed to clear app cache: $e');
                                      }
                                      break;
                                    default:
                                      InAppWebViewController.clearAllCache();
                                      break;
                                  }
                                }
                              }
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
