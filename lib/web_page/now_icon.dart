import 'dart:math';

import 'package:browser01/web_page/color/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class IconImageButton extends StatefulWidget {
  final Function? onClick;
  final Function? onLongClick;
  final String res;
  final double? rotation;
  final double? width;
  final double? radius;
  final bool isTheme;

  const IconImageButton(
      {super.key,
      this.onClick,
      required this.res,
      this.rotation,
      this.onLongClick,
      this.width = 50,
      this.radius = 25,
      this.isTheme = true});

  @override
  State<StatefulWidget> createState() => IconImageButtonState();
}

class IconImageButtonState extends State<IconImageButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: widget.width,
        height: 50,
        child: InkWell(
            onTap: widget.onClick != null ? () => widget.onClick!() : null,
            onLongPress:
                widget.onLongClick != null ? () => widget.onLongClick!() : null,
            borderRadius: BorderRadius.circular(widget.radius ?? 25),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: widget.rotation != null
                  ? Transform.rotate(
                      angle: pi * widget.rotation!,
                      child: Image.asset(
                        widget.res,
                        height: 20,
                        width: 20,
                        color: widget.isTheme
                            ? Theme.of(context).brightness == Brightness.light
                                ? ThemeColors.iconColorDark // 亮色主题下的颜色
                                : ThemeColors.iconColorLight
                            : Colors.white,
                      ))
                  : Image.asset(widget.res,
                      height: 20,
                      width: 20,
                      color: widget.isTheme
                          ? Theme.of(context).brightness == Brightness.light
                              ? ThemeColors.iconColorDark // 亮色主题下的颜色
                              : ThemeColors.iconColorLight
                          : Colors.white),
            )));
  }
}
