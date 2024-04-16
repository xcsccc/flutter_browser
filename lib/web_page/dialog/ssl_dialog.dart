import 'package:browser01/web_page/custom/custom.dart';
import 'package:browser01/web_page/main_view/view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../color/colors.dart';
import 'long_click_dialog.dart';

void showSSLDialog(SSLInfo info, BuildContext context) {
  showDialog(
      context: context,
      builder: (context) {
        return CustomBaseDialog(
           child:Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SelectableText(
                  S.of(context).certificateInfo,
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 15),
                  textAlign: TextAlign.left,
                ),
                const Divider(height: 15, color: Colors.transparent),
                SizedBox(
                    height: 300,
                    child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child:  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SelectableText(
                        S.of(context).issuedTo,
                        style: const TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 13),
                        textAlign: TextAlign.left,
                      ),
                      const Divider(height: 8, color: Colors.transparent),
                      SelectableText(
                        S.of(context).commonName,
                        style: const TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 13),
                        textAlign: TextAlign.left,
                      ),
                      const Divider(height: 8, color: Colors.transparent),
                      SelectableText(
                        info.name.isEmptyToStr(),
                        style: const TextStyle(
                            fontWeight: FontWeight.w300, fontSize: 13),
                        textAlign: TextAlign.left,
                      ),
                      const Divider(height: 8, color: Colors.transparent),
                      SelectableText(
                        S.of(context).organization,
                        style: const TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 13),
                        textAlign: TextAlign.left,
                      ),
                      const Divider(height: 8, color: Colors.transparent),
                      SelectableText(
                        info.oName.isEmptyToStr(),
                        style: const TextStyle(
                            fontWeight: FontWeight.w300, fontSize: 13),
                        textAlign: TextAlign.left,
                      ),
                      const Divider(height: 8, color: Colors.transparent),
                      SelectableText(
                        S.of(context).organizationUnit,
                        style: const TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 13),
                        textAlign: TextAlign.left,
                      ),
                      const Divider(height: 8, color: Colors.transparent),
                      SelectableText(
                        info.ouName.isEmptyToStr(),
                        style: const TextStyle(
                            fontWeight: FontWeight.w300, fontSize: 13),
                        textAlign: TextAlign.left,
                      ),
                      const Divider(height: 15, color: Colors.transparent),
                      SelectableText(
                        S.of(context).issuedBy,
                        style: const TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 13),
                        textAlign: TextAlign.left,
                      ),
                      const Divider(height: 8, color: Colors.transparent),
                      SelectableText(
                        S.of(context).commonName,
                        style: const TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 13),
                        textAlign: TextAlign.left,
                      ),
                      const Divider(height: 8, color: Colors.transparent),
                      SelectableText(
                        info.tName.isEmptyToStr(),
                        style: const TextStyle(
                            fontWeight: FontWeight.w300, fontSize: 13),
                        textAlign: TextAlign.left,
                      ),
                      const Divider(height: 8, color: Colors.transparent),
                      SelectableText(
                        S.of(context).organization,
                        style: const TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 13),
                        textAlign: TextAlign.left,
                      ),
                      const Divider(height: 8, color: Colors.transparent),
                      SelectableText(
                        info.tOName.isEmptyToStr(),
                        style: const TextStyle(
                            fontWeight: FontWeight.w300, fontSize: 13),
                        textAlign: TextAlign.left,
                      ),
                      const Divider(height: 15, color: Colors.transparent),
                      SelectableText(
                        S.of(context).issuedOn,
                        style: const TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 13),
                        textAlign: TextAlign.left,
                      ),
                      const Divider(height: 8, color: Colors.transparent),
                      SelectableText(
                        info.start.isEmptyToStr(),
                        style: const TextStyle(
                            fontWeight: FontWeight.w300, fontSize: 13),
                        textAlign: TextAlign.left,
                      ),
                      const Divider(height: 8, color: Colors.transparent),
                      SelectableText(
                        S.of(context).expiresOn,
                        style: const TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 13),
                        textAlign: TextAlign.left,
                      ),
                      const Divider(height: 8, color: Colors.transparent),
                      SelectableText(
                        info.end.isEmptyToStr(),
                        style: const TextStyle(
                            fontWeight: FontWeight.w300, fontSize: 13),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                )),
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
              ]),
        );
      });
}
