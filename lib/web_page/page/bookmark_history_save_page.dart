import 'package:browser01/web_page/custom/custom.dart';
import 'package:browser01/web_page/custom/image_path.dart';
import 'package:browser01/web_page/now_icon.dart';
import 'package:browser01/web_page/page/CommonPage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../color/colors.dart';
import '../model/history_info.dart';

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
            initialIndex: data,
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
                const HistoryPage(), // 第二个标签对应的页面
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


class HistoryPage extends StatefulWidget{
  const HistoryPage({super.key});

  @override
  State<StatefulWidget> createState() => _HistoryState();

}

class _HistoryState extends State<HistoryPage>{
  late List<HistoryInfo> list = HistoryInfo.getAll();
  @override
  Widget build(BuildContext context) {
    return CommonPage(
        bottomChild: Container(
          color: Colors.blueAccent,
        ),
        centerChild: GroupList(list:list),
        searchChange: (search) {
          setState(() {
            if(search.isEmpty){
              list = HistoryInfo.getAll();
            }else{
              list = list.where((element) => element.title.contains(search) || element.url.contains(search)).toList();
            }
          });
        });
  }

}

class GroupList extends StatefulWidget{
  final List<HistoryInfo> list;
  const GroupList({super.key, required this.list});

  @override
  State<StatefulWidget> createState() => _GroupListState();

}

enum GroupType{
  title,item
}

class GroupTitleInfo{
  final GroupType type;
  final String title;
  const GroupTitleInfo({required this.title,required this.type});
}

class GroupItemInfo{
  final GroupType type;
  final HistoryInfo info;
  const GroupItemInfo({required this.info,required this.type});
}

class _GroupListState extends State<GroupList>{

  List<Object> getGroupMap(){
    Map<String,List<HistoryInfo>> maps = {};
    for (var element in widget.list) {
      var name = element.time.formatTime(context);
      if(maps[name] == null){
        maps[name] = [];
      }
      maps[name]!.add(element);
    }
    List<Object> re = [];
    maps.forEach((key, value) {
      re.add(GroupTitleInfo(title: key, type: GroupType.title));
      for (var element in value) {
        re.add(GroupItemInfo(info: element, type: GroupType.item));
      }
    });
    return re;
  }

  @override
  Widget build(BuildContext context) {
    var items = getGroupMap();
    return items.isNotEmpty ? ListView.builder(itemCount: items.length,shrinkWrap: true,itemBuilder: (context,index){
      var item = items[index];
      if(item is GroupTitleInfo){
        return TimeTitleItem(title: item.title);
      }else {
        item as GroupItemInfo;
        return GroupInfoItem(url: item.info.url,title: item.info.title);
      }
    }) : Container(height: 0);
  }

}

class TimeTitleItem extends StatefulWidget{
  final String title;
  const TimeTitleItem({super.key, required this.title});

  @override
  State<StatefulWidget> createState() => _TimeTitleItemState();
}

class _TimeTitleItemState extends State<TimeTitleItem>{
  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.only(top: 5,bottom: 5),child: Text(widget.title,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w300)),);
  }
}


class GroupInfoItem extends StatefulWidget{
  final String url;
  final String title;
  final bool isShowUrl;

  const GroupInfoItem({super.key, required this.url, required this.title,this.isShowUrl = true});

  @override
  State<StatefulWidget> createState() => _GroupInfoItemState();

}

class _GroupInfoItemState extends State<GroupInfoItem>{
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
                    borderRadius:
                    BorderRadius.all(
                        Radius.circular(
                            5))),
                child: widget.url.extractDomainWithProtocol() ==
                    null
                    ? Image.asset(
                    AppImages.icon,
                    width: 20,
                    height: 20,
                    fit: BoxFit.cover)
                    : CachedNetworkImage(
                  imageUrl:widget.url
                      .iconUrl() ?? "",
                  errorWidget: (context,
                      url, error) {
                    return Image.asset(
                        AppImages.icon,
                        width: 20,
                        height: 20,
                        fit:
                        BoxFit.cover);
                  },
                )),
          ),
        ),
        Expanded(child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.title,maxLines: 1,overflow: TextOverflow.ellipsis,style: const TextStyle(fontSize: 15)),
            if(widget.isShowUrl) Text(widget.url,maxLines: 1,overflow: TextOverflow.ellipsis,style: const TextStyle(fontSize: 13,fontWeight: FontWeight.w300))
          ],
        ))
      ],
    );
  }

}
