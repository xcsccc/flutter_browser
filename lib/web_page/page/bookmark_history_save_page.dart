import 'package:browser01/web_page/custom/custom.dart';
import 'package:browser01/web_page/custom/image_path.dart';
import 'package:browser01/web_page/dialog/long_click_dialog.dart';
import 'package:browser01/web_page/model/SearchInfo.dart';
import 'package:browser01/web_page/model/bookmark_info.dart';
import 'package:browser01/web_page/model/file_type.dart';
import 'package:browser01/web_page/model/tree_node.dart';
import 'package:browser01/web_page/now_icon.dart';
import 'package:browser01/web_page/page/CommonPage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../generated/l10n.dart';
import '../color/colors.dart';
import '../model/history_info.dart';
import '../provider/main_provider.dart';

class BookmarkAndHistoryAndSavePage extends StatefulWidget {
  const BookmarkAndHistoryAndSavePage({super.key});

  @override
  State<StatefulWidget> createState() => BookmarkAndHistoryAndSaveState();
}

class BookmarkAndHistoryAndSaveState
    extends State<BookmarkAndHistoryAndSavePage> {
  @override
  Widget build(BuildContext context) {
    final SearchInfo data =
        ModalRoute.of(context)!.settings.arguments as SearchInfo;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: DefaultTabController(
        initialIndex: data.position,
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
               const BookmarkPage(),
                // 第一个标签对应的页面
                HistoryPage(search: data.position == 1 ? data.search : ""),
                // 第二个标签对应的页面
                CommonPage(
                    bottomChild: Container(
                      color: Colors.deepOrange,
                    ),
                    centerChild: Container(
                      height: 1000,
                      width: double.infinity,
                      color: Colors.blueAccent,
                    ),
                    searchChange: (search) {})
                // 第三个标签对应的页面
              ],
            )),
          ],
        ),
      )),
    );
  }
}

class HistoryPage extends StatefulWidget {
  final String search;

  const HistoryPage({super.key, required this.search});

  @override
  State<StatefulWidget> createState() => _HistoryState();
}

class _HistoryState extends State<HistoryPage> {
  late var provider = Provider.of<GlobalProvider>(context);
  late var search = widget.search;
  final GlobalKey _key = GlobalKey();

  List<HistoryInfo> getList() {
    if (search.isEmpty) {
      return provider.historyInfo;
    } else {
      return provider.historyInfo
          .where((element) =>
              element.title.contains(search) || element.url.contains(search))
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CommonPage(
        bottomChild: Row(
          children: [
            Expanded(child: Container()),
            InkWell(
              key: _key,
              onTap: () {
                if (getList().isNotEmpty) {
                  if (_key.currentContext != null) {
                    final RenderBox renderBox =
                        _key.currentContext?.findRenderObject() as RenderBox;
                    final Offset offset = renderBox.localToGlobal(Offset.zero);
                    showClearHistoryMenu(context,
                        offset.dx + renderBox.size.width / 2, offset.dy + 25);
                  }
                } else {
                  toastMsg(S.of(context).historyEmpty);
                }
              },
              borderRadius: BorderRadius.circular(15),
              child: SizedBox(
                height: 50,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Text(
                    S.of(context).historyClear,
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
              ),
            )
          ],
        ),
        searchInit: widget.search,
        centerChild: getList().isNotEmpty
            ? GroupList(list: getList())
            : Padding(
                padding: const EdgeInsets.only(top: 150),
                child: Center(
                    child: Image.asset(
                  AppImages.empty,
                  width: 120,
                  height: 120,
                ))),
        searchChange: (search) {
          setState(() {
            this.search = search;
          });
        });
  }
}

class GroupList extends StatefulWidget {
  final List<HistoryInfo> list;

  const GroupList({super.key, required this.list});

  @override
  State<StatefulWidget> createState() => _GroupListState();
}

enum GroupType { title, item }

class GroupTitleInfo {
  final GroupType type;
  final String title;

  const GroupTitleInfo({required this.title, required this.type});
}

class GroupItemInfo<T> {
  final GroupType type;
  final T info;

  const GroupItemInfo({required this.info, required this.type});
}

class _GroupListState extends State<GroupList> {
  List<Object> getGroupMap() {
    Map<String, List<HistoryInfo>> maps = {};
    for (var element in widget.list) {
      var name = element.time.formatTime(context);
      if (maps[name] == null) {
        maps[name] = [];
      }
      maps[name]!.add(element);
    }
    List<Object> re = [];
    maps.forEach((key, value) {
      re.add(GroupTitleInfo(title: key, type: GroupType.title));
      for (var element in value) {
        re.add(GroupItemInfo<HistoryInfo>(info: element, type: GroupType.item));
      }
    });
    return re;
  }

  @override
  Widget build(BuildContext context) {
    var items = getGroupMap();
    return items.isNotEmpty
        ? ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              var item = items[index];
              if (item is GroupTitleInfo) {
                return TimeTitleItem(title: item.title);
              } else {
                item as GroupItemInfo;
                return GroupInfoItem(info: item.info);
              }
            })
        : Container(height: 0);
  }
}

class TimeTitleItem extends StatefulWidget {
  final String title;

  const TimeTitleItem({super.key, required this.title});

  @override
  State<StatefulWidget> createState() => _TimeTitleItemState();
}

class _TimeTitleItemState extends State<TimeTitleItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 5),
      child: Text(widget.title,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w300)),
    );
  }
}

class GroupInfoItem extends StatefulWidget {
  final HistoryInfo info;
  final bool isShowUrl;

  const GroupInfoItem({super.key, this.isShowUrl = true, required this.info});

  @override
  State<StatefulWidget> createState() => _GroupInfoItemState();
}

class _GroupInfoItemState extends State<GroupInfoItem> {
  TapDownDetails? details;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTapDown: (details) {
        this.details = details;
      },
      onTap: () {
        Navigator.of(context)
            .pop(UrlOpenType(url: widget.info.url, isNowOpen: true));
      },
      onLongPress: () {
        if (details != null) {
          showHistoryMenu(context, details!.globalPosition.dx,
              details!.globalPosition.dy, widget.info);
        }
      },
      borderRadius: BorderRadius.circular(0),
      child:
          Item(url: widget.info.url, title: widget.info.title, isShowUrl: true,iconPath: AppImages.icon,),
    );
  }
}

class Item extends StatefulWidget {
  final String url;
  final String title;
  final bool isShowUrl;
  final String? iconPath;

  const Item(
      {super.key,
      required this.url,
      required this.title,
      required this.isShowUrl, this.iconPath});

  @override
  State<StatefulWidget> createState() => ItemState();
}

class ItemState extends State<Item> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 50,
          width: 50,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: DecoratedBox(
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: widget.iconPath != null ? Image.asset(widget.iconPath!,
                    width: 20, height: 20, fit: BoxFit.cover) : widget.url.extractDomainWithProtocol() == null
                    ? Image.asset(widget.iconPath!,
                    width: 20, height: 20, fit: BoxFit.cover) : CachedNetworkImage(
                        imageUrl: widget.url.iconUrl() ?? "",
                        errorWidget: (context, url, error) {
                          return Image.asset(AppImages.icon,
                              width: 20, height: 20, fit: BoxFit.cover);
                        },
                      )),
          ),
        ),
        Expanded(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 15)),
            if (widget.isShowUrl)
              Text(widget.url,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w300))
          ],
        ))
      ],
    );
  }
}

class BookmarkPage extends StatefulWidget {
  const BookmarkPage({super.key});

  @override
  State<StatefulWidget> createState() => BookmarkState();
}

class BookmarkState extends State<BookmarkPage> {
  late var search = "";
  bool isSelect = false;

  List<TreeNode> getList() {
    late var provider = context.read<GlobalProvider>();
    if (search.isEmpty) {
      return provider.treeNodeInfo.children;
    } else {
      return provider.treeNodeInfo.children
          .where((element) =>
              element.info.title.contains(search))
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    var items = getList();
    return CommonPage(
        bottomChild: isSelect ? select() : unselect(),
        centerChild: items.isNotEmpty
            ? ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: items.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  var item = items[index];
                  return BookmarkItem(info: item);
                })
            : Padding(
                padding: const EdgeInsets.only(top: 150),
                child: Center(
                    child: Image.asset(
                  AppImages.empty,
                  width: 120,
                  height: 120,
                ))),
        searchChange: (search) {
          setState(() {
            this.search = search;
          });
        });
  }

  Widget unselect() {
    return Container();
  }

  Widget select() {
    return Container();
  }
}

class BookmarkItem extends StatefulWidget {
  final TreeNode info;

  const BookmarkItem({super.key, required this.info});

  @override
  State<StatefulWidget> createState() => BookmarkItemState();
}

class BookmarkItemState extends State<BookmarkItem> {
  TapDownDetails? details;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTapDown: (details) {
          this.details = details;
        },
        onTap: () {
          if(widget.info.fileType == FileType.bookmark){
            Navigator.of(context)
                .pop(UrlOpenType(url: widget.info.info.url, isNowOpen: true));
          }
        },
        onLongPress: () {
          if (details != null) {

          }
        },
        borderRadius: BorderRadius.circular(0),
        child: Item(
            url: widget.info.info.url, title: widget.info.info.title, isShowUrl: false,iconPath: widget.info.fileType == FileType.bookmark ? AppImages.folder : AppImages.bookmark,));
  }
}
