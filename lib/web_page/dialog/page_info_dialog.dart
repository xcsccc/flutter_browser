import 'package:browser01/web_page/dialog/long_click_dialog.dart';
import 'package:flutter/material.dart';
import '../../generated/l10n.dart';
import '../color/colors.dart';

void showPageInfoDialog(
    String title, String url, String linkUrl, BuildContext context) {
  showDialog(
      context: context,
      builder: (context) {
        return CustomBaseDialog(
            child: SizedBox(
              width: double.infinity,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisSize:MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SelectableText(
                      S.of(context).pageInfo,
                      style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                      textAlign: TextAlign.left,
                    ),
                    const Divider(height: 15, color: Colors.transparent),
                    SelectableText(
                      S.of(context).dialogTitle,
                      style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                      textAlign: TextAlign.left,
                    ),
                    const Divider(height: 5, color: Colors.transparent),
                    SelectableText(
                      title,
                      style: const TextStyle(fontSize: 12),
                      textAlign: TextAlign.left,
                    ),
                    const Divider(height: 15, color: Colors.transparent),
                    SelectableText(
                      S.of(context).pageUrl,
                      style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                      textAlign: TextAlign.left,
                    ),
                    const Divider(height: 5, color: Colors.transparent),
                    SelectableText(
                      url,
                      style: const TextStyle(fontSize: 12),
                      textAlign: TextAlign.left,
                    ),
                    const Divider(height: 15, color: Colors.transparent),
                    SelectableText(
                      S.of(context).linkUrl,
                      style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                      textAlign: TextAlign.left,
                    ),
                    const Divider(height: 5, color: Colors.transparent),
                    SelectableText(
                      linkUrl,
                      style: const TextStyle(fontSize: 12),
                      textAlign: TextAlign.left,
                    ),
                    const Divider(height: 20, color: Colors.transparent),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          S.of(context).ok,
                          style: TextStyle(
                              fontSize: 15, color: ThemeColors.progressStartColor),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ));
      });
}
