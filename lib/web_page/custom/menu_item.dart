import 'package:browser01/web_page/custom/custom.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import '../color/colors.dart';
import '../provider/main_provider.dart';

class MenuItem extends StatefulWidget {
  final Function? onClick;
  final Function? onLongClick;
  final String res;
  final String title;
  final FuncBottomType type;

  const MenuItem(
      {super.key,
      required this.onClick,
      this.onLongClick,
      required this.res,
      required this.title,
      required this.type});

  @override
  State<StatefulWidget> createState() => _MenuItemState();
}

class _MenuItemState extends State<MenuItem> {
  late var provider = Provider.of<GlobalProvider>(context);

  Color getNowIconColor() {
    bool isEnable = false;
    provider.nowClickType;
    switch (widget.type) {
      case FuncBottomType.night:
        isEnable = Hive.box(boolKey).get(nightModeKey, defaultValue: false);
        break;
      case FuncBottomType.addBookmark:
        isEnable = false;
        break;
      case FuncBottomType.desktop:
        isEnable = Hive.box(boolKey).get(desktopKey, defaultValue: false);
        break;
      case FuncBottomType.hide:
        isEnable = Hive.box(boolKey).get(hideKey, defaultValue: false);
        break;
      case FuncBottomType.imageMode:
        isEnable = false;
        break;
      case FuncBottomType.browserFlag:
        isEnable = false;
        break;
      case FuncBottomType.full:
        isEnable = Hive.box(boolKey).get(fullKey, defaultValue: false);
        break;
      default:
        isEnable = false;
        break;
    }
    Color nowColor;
    if (!isEnable) {
      nowColor = Theme.of(context).brightness == Brightness.light
          ? ThemeColors.iconColorDark
          : ThemeColors.iconColorLight;
    } else {
      nowColor = ThemeColors.progressStartColor;
    }
    return nowColor;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onClick != null ? () => widget.onClick!() : null,
      onLongPress:
          widget.onLongClick != null ? () => widget.onLongClick!() : null,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: Column(
          children: [
            Padding(
                padding: const EdgeInsets.all(10),
                child: Image.asset(widget.res,
                    height: 20, width: 20, color: getNowIconColor())),
            Expanded(
                child: Text(
              widget.title,
              style: TextStyle(fontSize: 12, color: getNowIconColor()),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              textAlign: TextAlign.center,
            ))
          ],
        ),
      ),
    );
  }
}
