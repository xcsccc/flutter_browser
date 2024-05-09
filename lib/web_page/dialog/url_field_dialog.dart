import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import '../../generated/l10n.dart';
import '../color/colors.dart';
import '../custom/custom.dart';
import '../provider/main_provider.dart';
import 'long_click_dialog.dart';

void showUrlFieldContentDialog(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) {
        return const UrlFieldContentDialog();
      });
}

class UrlFieldContentDialog extends StatefulWidget {
  const UrlFieldContentDialog({super.key});

  @override
  State<StatefulWidget> createState() => UrlFieldContentState();
}

class UrlFieldContentState extends State<UrlFieldContentDialog> {
  var list = UrlFieldContentType.values;
  late var provider = Provider.of<GlobalProvider>(context, listen: false);

  @override
  Widget build(BuildContext context) {

    var selectValue = UrlFieldContentType.values.indexOf(provider.urlFieldType);

    return Dialog(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        child: Container(
            decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.light ? Colors.white : ThemeColors.iconColorDark,
                border: Border.all(
                    color: Theme.of(context).brightness == Brightness.light
                        ? ThemeColors.iconColorLight
                        : ThemeColors.iconColorDark,
                    width: 1),
                borderRadius: const BorderRadius.all(Radius.circular(20))),
            child: Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 15, right: 15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: EdgeInsets.only(left: 15,bottom: 15),
                        child: Text("Search Engine", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      )),
                  ListView.builder(
                      itemCount: list.length,
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        var item = list[index];
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectValue = index;
                              Hive.box(intKey).put(urlFieldKey, index);
                              provider.changeUrlFieldContentSetting(item);
                              Navigator.of(context).pop();
                            });
                          },
                          child: Container(
                            color: Colors.transparent,
                            child: Row(
                              children: [
                                Radio(
                                  value: index,
                                  groupValue: selectValue,
                                  onChanged: (value) {
                                    setState(() {
                                      selectValue = index;
                                      Hive.box(intKey).put(urlFieldKey, index);
                                      provider.changeUrlFieldContentSetting(item);
                                      Navigator.of(context).pop();
                                    });
                                  },
                                  activeColor: ThemeColors.progressStartColor,
                                ),
                                Text(
                                  item.urlName,
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: index == selectValue
                                          ? ThemeColors.progressStartColor
                                          : Theme.of(context).textTheme.bodyMedium?.color),
                                ),
                              ],
                            ),
                          ),
                        );
                      })
                ],
              ),
            )));
  }
}
