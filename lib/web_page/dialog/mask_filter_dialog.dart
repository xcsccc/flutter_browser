import 'dart:ffi';
import 'dart:io';

import 'package:browser01/web_page/custom/custom.dart';
import 'package:browser01/web_page/model/history_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../../generated/l10n.dart';
import '../color/colors.dart';
import '../provider/main_provider.dart';
import 'long_click_dialog.dart';

void showMaskDialog(BuildContext context, Function(int alpha) onClick) {
  var list = ClearDataType.values.toList();
  showDialog(
      context: context,
      builder: (context) {
        return MaskFilterDialog(
          maskAlpha: 40,
          changeAlpha: onClick,
        );
      });
}

class MaskFilterDialog extends StatefulWidget {
  MaskFilterDialog({super.key, required this.maskAlpha, required this.changeAlpha});

  Function(int) changeAlpha;

  int maskAlpha = 40;

  @override
  State<StatefulWidget> createState() => MaskFilterState();
}

class MaskFilterState extends State<MaskFilterDialog> {
  @override
  Widget build(BuildContext context) {
    widget.maskAlpha = Hive.box(intKey).get(maskAlphaKey, defaultValue: 40);
    return CustomBaseDialog(
      child: SizedBox(
        height: 140,
        width: double.infinity,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: SizedBox(
                width: double.infinity,
                height: 60,
                child: Stack(alignment: Alignment.center, children: [
                  Text("Wishing you all the best",
                      style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.light
                              ? ThemeColors.iconColorDark
                              : Colors.white)),
                  Positioned.fill(
                      child: Container(
                          decoration: BoxDecoration(
                              color: (Theme.of(context).brightness == Brightness.light
                                      ? const Color(0xFF848484)
                                      : const Color(0xFF121212))
                                  .withOpacity(widget.maskAlpha / 100),
                              borderRadius: BorderRadius.circular(15.0))))
                ]),
              ),
            ),
            Slider(
                value: widget.maskAlpha.toDouble(),
                min: 0,
                max: 80,
                onChanged: (value) {
                  setState(() {
                    widget.maskAlpha = value.toInt();
                    Hive.box(intKey).put(maskAlphaKey, value.toInt());
                    widget.changeAlpha(value.toInt());
                  });
                })
          ],
        ),
      ),
    );
  }
}
