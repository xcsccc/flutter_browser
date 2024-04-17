import 'package:browser01/web_page/custom/custom.dart';
import 'package:browser01/web_page/custom/image_path.dart';
import 'package:browser01/web_page/now_icon.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import '../../generated/l10n.dart';
import '../color/colors.dart';
import '../provider/main_provider.dart';

class TopSearchBar extends StatefulWidget {
  final ValueChanged<String> onSearch;
  final String searchKey;

  const TopSearchBar(
      {super.key, required this.searchKey, required this.onSearch});

  @override
  State<StatefulWidget> createState() => TopSearchState();
}

class TopSearchState extends State<TopSearchBar> {
  String searchString = "";
  FocusNode node = FocusNode();
  late TextEditingController _controller;

  late var provider = Provider.of<GlobalProvider>(context, listen: false);
  var list = SearchEnginType.values;
  GlobalKey globalKey = GlobalKey();

  @override
  void initState() {
    searchString = widget.searchKey;
    _controller = TextEditingController(text: searchString);
    super.initState();
    node.requestFocus();
    _controller.selection = TextSelection(
      baseOffset: 0,
      extentOffset: _controller.text.length,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  void showEnginDialog(BuildContext context, double showX, double showY) {
    var selectValue = SearchEnginType.values.indexOf(provider.selectEngin);
    OverlayEntry? overlayEntry;
    overlayEntry = OverlayEntry(builder: (BuildContext newContext) {
      return Scaffold(
          backgroundColor: Colors.transparent,
          body: Visibility(
              visible: provider.isShowFunDialog,
              maintainState: true,
              child: Stack(children: [
                GestureDetector(
                  onTap: () {
                    overlayEntry?.remove();
                  },
                  behavior:
                      HitTestBehavior.translucent, // 设置为translucent以便接收点击事件
                ),
                Positioned(
                    width: 150,
                    left: showX,
                    top: showY,
                    child: Container(
                        decoration: BoxDecoration(
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? Colors.white
                                    : ThemeColors.iconColorDark,
                            border: Border.all(
                                color: Theme.of(context).brightness ==
                                        Brightness.light
                                    ? ThemeColors.iconColorLight
                                    : ThemeColors.iconColorDark,
                                width: 1),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20))),
                        child: ListView.builder(
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
                                    Hive.box(intKey).put(searchEnginKey, index);
                                    provider.changeSearchEngin(item);
                                    overlayEntry?.remove();
                                  });
                                },
                                child: Container(color: Colors.transparent,child: Row(
                                  children: [
                                    Radio(
                                      value: index,
                                      groupValue: selectValue,
                                      onChanged: (value){
                                        setState(() {
                                          selectValue = index;
                                          Hive.box(intKey).put(searchEnginKey, index);
                                          provider.changeSearchEngin(item);
                                          overlayEntry?.remove();
                                        });
                                      },
                                      activeColor: ThemeColors.progressStartColor,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text(
                                        item.enginName,
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: index == selectValue
                                                ? ThemeColors.progressStartColor
                                                : Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.color),
                                      ),
                                    )
                                  ],
                                ),
                              ),);
                            })))
              ])));
    });
    Overlay.of(context).insert(overlayEntry);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Row(children: [
        IconImageButton(
            key: globalKey,
            res: AppImages.search,
            onClick: () {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                final RenderBox renderBox =
                    globalKey.currentContext!.findRenderObject() as RenderBox;
                final position = renderBox.localToGlobal(Offset.zero);
                showEnginDialog(context, 50, position.dy + 25);});
            }),
        Expanded(
            flex: 1,
            child: SizedBox(
                height: 50,
                child: TextField(
                  focusNode: node,
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: S.of(context).search,
                    border: InputBorder.none,
                    hintStyle: const TextStyle(fontSize: 15),
                  ),
                  maxLines: 1,
                  onChanged: (value) {
                    setState(() {
                      searchString = value;
                    });
                  },
                  style: const TextStyle(fontSize: 15),
                  onSubmitted: (search) {
                    if (searchString.isNotEmpty) {
                      if (searchString != widget.searchKey) {
                        widget.onSearch(searchString);
                        node.unfocus();
                      }
                    }
                  },
                ))),
        IconImageButton(
            onClick: () {
              if (searchString.isNotEmpty) {
                if (searchString != widget.searchKey) {
                  widget.onSearch(searchString);
                  node.unfocus();
                }
              }
            },
            res: AppImages.back,
            rotation: 1)
      ]),
    );
  }
}
