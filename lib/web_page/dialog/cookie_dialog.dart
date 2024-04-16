import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../../generated/l10n.dart';
import '../color/colors.dart';
import 'long_click_dialog.dart';

void showCookiesDialog(List<Cookie> cookies, String url, BuildContext context) {
  var cookiesStr = "";
  for (Cookie cookie in cookies) {
    cookiesStr += cookie.value;
  }
  showDialog(
      context: context,
      builder: (context) {
        return CustomBaseDialog(
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SelectableText(
                  S.of(context).cookieTitle(Uri.parse(url).host),
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 15),
                  textAlign: TextAlign.left,
                ),
                const Divider(height: 15, color: Colors.transparent),
                ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 300),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SelectableText(
                            cookiesStr,
                            style: const TextStyle(
                                fontWeight: FontWeight.w300, fontSize: 14),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    )),
                const Divider(height: 20, color: Colors.transparent),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    children: [
                      Expanded(child: Container()),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          S.of(context).cancel,
                          style: TextStyle(
                              fontSize: 15,
                              color: ThemeColors.progressStartColor),
                        ),
                      ),
                      Container(width: 10),
                      GestureDetector(
                        onTap: () {
                          copyToClipboard(cookiesStr, context);
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          S.of(context).copyText,
                          style: TextStyle(
                              fontSize: 15,
                              color: ThemeColors.progressStartColor),
                        ),
                      )
                    ],
                  ),
                )
              ]),
        );
      });
}
