import 'package:browser01/web_page/color/colors.dart';
import 'package:flutter/material.dart';

import '../../generated/l10n.dart';

class CommonPage extends StatefulWidget {
  final Widget bottomChild;
  final Widget centerChild;
  final Function(String) searchChange;
  final String searchInit;

  const CommonPage(
      {super.key,
      required this.bottomChild,
      required this.centerChild,
      required this.searchChange,this.searchInit = ""});

  @override
  State<StatefulWidget> createState() => _CommonState();
}

class _CommonState extends State<CommonPage> {
  late TextEditingController controller = TextEditingController(text:widget.searchInit);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20)),
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? ThemeColors.borderColor
                                    : ThemeColors
                                        .indicatorLightGraySelectColorBlack),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: TextField(
                            controller: controller,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: S.of(context).search,
                              fillColor: Colors.transparent,
                              hintStyle: const TextStyle(fontSize: 15),
                            ),
                            maxLines: 1,
                            onChanged: (value) {
                              setState(() {
                                widget.searchChange(value);
                              });
                            },
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: widget.centerChild,
                    ),
                  ],
                ))),
        const Divider(height: 1),
        SizedBox(
          height: 50,
          width: double.infinity,
          child: widget.bottomChild,
        )
      ],
    );
  }
}
