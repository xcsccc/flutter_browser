import 'package:browser01/web_page/custom/image_path.dart';
import 'package:browser01/web_page/now_icon.dart';
import 'package:browser01/web_page/page/CommonPage.dart';
import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../color/colors.dart';

class BookmarkAndHistoryAndSavePage extends StatefulWidget {
  const BookmarkAndHistoryAndSavePage({super.key});

  @override
  State<StatefulWidget> createState() => BookmarkAndHistoryAndSaveState();
}

class BookmarkAndHistoryAndSaveState
    extends State<BookmarkAndHistoryAndSavePage> {
  @override
  Widget build(BuildContext context) {
    final int data = ModalRoute.of(context)!.settings.arguments as int;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: DefaultTabController(
        length: 3, // 标签数量
        child: Column(
          children: [
            Row(
              children: [
                IconImageButton(
                  res: AppImages.back,
                  onClick: () {
                    Navigator.of(context).pop();
                  },
                ),
                Expanded(
                  child: TabBar(
                    indicatorColor: Colors.transparent,
                    indicator: const BoxDecoration(color: Colors.transparent),
                    unselectedLabelColor:
                        ThemeColors.indicatorLightGrayUnSelectColorBlack,
                    labelColor: Theme.of(context).brightness == Brightness.light
                        ? ThemeColors.iconColorDark
                        : ThemeColors.iconColorLight,
                    tabs: [
                      Tab(text: S.of(context).bookmark),
                      Tab(text: S.of(context).history),
                      Tab(text: S.of(context).noNetworkHtml),
                    ],
                  ),
                )
              ],
            ),
            const Divider(height: 1),
            Expanded(
                child: TabBarView(
              physics: const BouncingScrollPhysics(),
              // 根据标签切换显示不同的内容
              children: [
                CommonPage(
                    bottomChild: Container(

                      color: Colors.blueAccent,
                    ),
                    centerChild: Container(
                      height: 1000,
                      width: double.infinity,
                      color: Colors.amberAccent,
                    ),
                    searchChange: (search) {}), // 第一个标签对应的页面
                CommonPage(
                    bottomChild: Container(
                      color: Colors.amberAccent,
                    ),
                    centerChild: Container(
                      height: 1000,
                      width: double.infinity,
                      color: Colors.deepOrange,
                    ),
                    searchChange: (search) {}), // 第二个标签对应的页面
                CommonPage(
                    bottomChild: Container(

                      color: Colors.deepOrange,
                    ),
                    centerChild: Container(
                      height: 1000,
                      width: double.infinity,
                      color: Colors.blueAccent,
                    ),
                    searchChange: (search) {}) // 第三个标签对应的页面
              ],
            )),
          ],
        ),
      )),
    );
  }
}
