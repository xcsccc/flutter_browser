import 'package:browser01/web_page/color/colors.dart';
import 'package:browser01/web_page/custom/custom.dart';
import 'package:browser01/web_page/custom/menu_item.dart';
import 'package:browser01/web_page/custom/page_indicator.dart';
import 'package:browser01/web_page/now_icon.dart';
import 'package:browser01/web_page/provider/main_provider.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../generated/l10n.dart';
import '../custom/func_bottom_info.dart';
import '../custom/image_path.dart';

class FuncBottomDialog extends StatefulWidget {
  final Function(FuncBottomType) onClick;
  const FuncBottomDialog({super.key,required this.onClick});

  @override
  State<StatefulWidget> createState() => FuncBottomState();
}

class FuncBottomState extends State<FuncBottomDialog> {
  late List<FuncBottomInfo> funcInitList;
  late var provider = Provider.of<GlobalProvider>(context, listen: false);
  late List<FuncBottomInfo> funcBottomInfoList;
  bool isFirst = true;

  List<List<FuncBottomInfo>> showInfo = [];
  var control = PageController(initialPage: 0);
  var select = 0;


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if(isFirst){
      isFirst = false;
      funcInitList = [
        FuncBottomInfo(
            iconRes: AppImages.night,
            name: S.of(context).night,
            isShow: true,type: FuncBottomType.night.index),
        FuncBottomInfo(
            iconRes: AppImages.bookmark,
            name: S.of(context).bookmark,
            isShow: true,type: FuncBottomType.bookmark.index),
        FuncBottomInfo(
            iconRes: AppImages.history,
            name: S.of(context)!.history,
            isShow: true,type: FuncBottomType.history.index),
        FuncBottomInfo(
            iconRes: AppImages.download,
            name: S.of(context).download,
            isShow: true,type: FuncBottomType.download.index),
        FuncBottomInfo(
            iconRes: AppImages.hide,
            name: S.of(context).hide,
            isShow: true,type: FuncBottomType.hide.index),
        FuncBottomInfo(
            iconRes: AppImages.share,
            name: S.of(context).share,
            isShow: true,type: FuncBottomType.share.index),
        FuncBottomInfo(
            iconRes: AppImages.addBookmark,
            name: S.of(context).addBookmark,
            isShow: true,type: FuncBottomType.addBookmark.index),
        FuncBottomInfo(
            iconRes: AppImages.desktop,
            name: S.of(context).desktop,
            isShow: true,type: FuncBottomType.desktop.index),
        FuncBottomInfo(
            iconRes: AppImages.tool,
            name: S.of(context).tool,
            isShow: true,type: FuncBottomType.tool.index),
        FuncBottomInfo(
            iconRes: AppImages.setting,
            name: S.of(context).setting,
            isShow: true,type: FuncBottomType.setting.index),
        FuncBottomInfo(
            iconRes: AppImages.find,
            name: S.of(context).find,
            isShow: true,type: FuncBottomType.find.index),
        FuncBottomInfo(
            iconRes: AppImages.save,
            name: S.of(context).save,
            isShow: true,type: FuncBottomType.save.index),
        FuncBottomInfo(
            iconRes: AppImages.translate,
            name: S.of(context).translate,
            isShow: true,type: FuncBottomType.translate.index),
        FuncBottomInfo(
            iconRes: AppImages.code,
            name: S.of(context).code,
            isShow: true,type: FuncBottomType.code.index),
        FuncBottomInfo(
            iconRes: AppImages.full,
            name: S.of(context).full,
            isShow: true,type: FuncBottomType.full.index),
        FuncBottomInfo(
            iconRes: AppImages.imageMode,
            name: S.of(context).imageMode,
            isShow: true,type: FuncBottomType.imageMode.index),
        FuncBottomInfo(
            iconRes: AppImages.browserFlag,
            name: S.of(context).browserFlag,
            isShow: true,type: FuncBottomType.browserFlag.index),
        FuncBottomInfo(
            iconRes: AppImages.refresh,
            name: S.of(context).refresh,
            isShow: true,type: FuncBottomType.refresh.index),
        FuncBottomInfo(
            iconRes: AppImages.network,
            name: S.of(context).network,
            isShow: true,type: FuncBottomType.network.index),
        FuncBottomInfo(
            iconRes: AppImages.findRes,
            name: S.of(context).findRes,
            isShow: true,type: FuncBottomType.findRes.index),
        FuncBottomInfo(
            iconRes: AppImages.noNetworkHtml,
            name: S.of(context).noNetworkHtml,
            isShow: false,type: FuncBottomType.noNetworkHtml.index),
        FuncBottomInfo(
            iconRes: AppImages.scanner,
            name: S.of(context).scan,
            isShow: false,type: FuncBottomType.scan.index),
        FuncBottomInfo(
            iconRes: AppImages.fontSize,
            name: S.of(context).fontSize,
            isShow: false,type: FuncBottomType.fontSize.index),
        FuncBottomInfo(
            iconRes: AppImages.clear,
            name: S.of(context).clear,
            isShow: false,type: FuncBottomType.clear.index),
        FuncBottomInfo(
            iconRes: AppImages.pdf,
            name: S.of(context).pdf,
            isShow: false,type: FuncBottomType.pdf.index),
      ];
      funcBottomInfoList = provider
          .getFuncBottomInfoList(funcInitList)
          .where((element) => element.isShow)
          .toList();
      for (var info in funcBottomInfoList) {
        info.name = funcInitList.where((element) => element.type == info.type).toList().first.name;
      }
      var list = funcBottomInfoList.where((element) => element.isShow).toList();
      int j = -1;
      for (int index = 0; index < list.length; index++) {
        if (index % 10 == 0) {
          j++;
          showInfo.add([]);
        }
        showInfo[j].add(list[index]);
      }
    }

  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Dialog(
            shadowColor: Colors.transparent,
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.all(0),
            child: Container(
                alignment: Alignment.bottomLeft,
                child: GestureDetector(
                  onTap: () {},
                  child: Material(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.white
                        : ThemeColors.iconColorDark,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Divider(
                          height: 10,
                          color: Colors.transparent,
                        ),
                        ExpandablePageView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: showInfo.length,
                          controller: control,
                          onPageChanged: (position){
                            setState(() {
                              select = position;
                            });
                          },
                          itemBuilder: (context, index) {
                            return FuncBottomItem(nowList: showInfo[index],onClick:widget.onClick);
                          },
                        ),
                        const Divider(height: 10, color: Colors.transparent),
                        SizedBox(height: 14,child:ListView.builder(
                            itemCount: showInfo.length,
                            itemExtent: 14,
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return PageIndicator(
                                  select: index == select);
                            }) ,),
                        const Divider(height: 10, color: Colors.transparent),
                        Row(
                          children: [
                            Expanded(child: Container()),
                            IconImageButton(res: AppImages.powerOff,onClick: (){
                              //退出程序
                              SystemNavigator.pop();
                            }),
                            IconImageButton(res: AppImages.back,rotation: -0.5,onClick: (){
                              Navigator.of(context).pop();
                            },)
                          ],
                        )
                      ],
                    ),
                  ),
                ))),
      ),
    );
  }
}

class FuncBottomItem extends StatefulWidget {
  final List<FuncBottomInfo> nowList;
  final Function(FuncBottomType) onClick;

  const FuncBottomItem({super.key, required this.nowList, required this.onClick});

  @override
  State<StatefulWidget> createState() => FuncBottomItemState();
}

class FuncBottomItemState extends State<FuncBottomItem> {
  late var provider = Provider.of<GlobalProvider>(context);
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.all(0),
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5, crossAxisSpacing: 0, mainAxisSpacing: 0),
        itemCount: widget.nowList.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          var item = widget.nowList[index];
          return MenuItem(
              onClick: () {
                widget.onClick(FuncBottomType.values[item.type]);
              },
              onLongClick: () {},
              res: item.iconRes,
              title: item.name,type:FuncBottomType.values[item.type] ,);
        });
  }
}
