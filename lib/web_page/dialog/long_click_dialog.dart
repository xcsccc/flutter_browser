// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:isolate';
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:browser01/web_page/color/colors.dart';
import 'package:browser01/web_page/custom/image_path.dart';
import 'package:browser01/web_page/dialog/page_info_dialog.dart';
import 'package:browser01/web_page/model/history_info.dart';
import 'package:browser01/web_page/provider/main_provider.dart';
import 'package:browser01/web_page/web_main_page.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_qr_reader/flutter_qr_reader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../../generated/l10n.dart';
import '../custom/custom.dart';

List<String> _findName(List<FunDialogType> list, BuildContext context) {
  return list.map((element) {
    switch (element) {
      case FunDialogType.openBackground:
        return S.of(context).openBg;
      case FunDialogType.openNew:
        return S.of(context).openNew;
      case FunDialogType.viewImage:
        return S.of(context).viewImage;
      case FunDialogType.saveImage:
        return S.of(context).saveImage;
      case FunDialogType.shareImage:
        return S.of(context).shareImage;
      case FunDialogType.pictureMode:
        return S.of(context).pictureMode;
      case FunDialogType.pageInfo:
        return S.of(context).pageInfo;
      case FunDialogType.copyLinkText:
        return S.of(context).copyLinkText;
      case FunDialogType.scanQR:
        return S.of(context).scanQR;
      case FunDialogType.copyLink:
        return S.of(context).copyLink;
      case FunDialogType.share:
        return S.of(context).share;
      case FunDialogType.delete:
        return S.of(context).delete;
      default:return "";
    }
  }).toList();
}

enum FunDialogType {
  openBackground,
  openNew,
  viewImage,
  saveImage,
  shareImage,
  pictureMode,
  pageInfo,
  copyLinkText,
  scanQR,
  copyLink,
  delete,
  allTime,
  allLastSeven,
  todayAndYesterday,
  oneHour,
  share;

  const FunDialogType();
}

List<FunDialogType> _findDialogTypeList(RequestFocusNodeHrefResult result) {
  return FunDialogType.values.where((element) {
    if (result.url != null && result.src == null) {
      return element == FunDialogType.openBackground ||
          element == FunDialogType.openNew ||
          element == FunDialogType.copyLink ||
          element == FunDialogType.copyLinkText ||
          element == FunDialogType.pageInfo ||
          element == FunDialogType.share;
    } else if (result.src != null && result.url == null) {
      return element == FunDialogType.viewImage &&
          element == FunDialogType.saveImage &&
          element == FunDialogType.shareImage &&
          element == FunDialogType.pictureMode &&
          element == FunDialogType.pageInfo &&
          element == FunDialogType.scanQR &&
          element == FunDialogType.share;
    } else {
      return true;
    }
  }).toList();
}

void showCustom(
    BuildContext context,
    double x,
    double y,
    List<FunDialogType> list,
    List<String> initList,
    GlobalProvider provider,
    Future<void> Function(FunDialogType, OverlayEntry?) onTop,[String? title]) {
  provider.showFunDialog();
  OverlayEntry? overlayEntry;
  overlayEntry = OverlayEntry(
    builder: (BuildContext newContext) {
      return LongDialogWidget(list: list, initList: initList, x: x, y: y, overlayEntry: overlayEntry!, onTop: onTop,title: title);
    },
  );

  Overlay.of(context).insert(overlayEntry);
}

class LongDialogWidget extends StatefulWidget{
  final List<FunDialogType> list;
  final List<String> initList;
  final double x;
  final double y;
  final OverlayEntry overlayEntry;
  final String? title;
  final Future<void> Function(FunDialogType, OverlayEntry?) onTop;

  const LongDialogWidget({super.key, required this.list, required this.initList, required this.x, required this.y, required this.overlayEntry, this.title, required this.onTop});

  @override
  State<StatefulWidget> createState() =>LongDialogState();

}

class LongDialogState extends State<LongDialogWidget>{
  late var provider = Provider.of<GlobalProvider>(context, listen: false);
  double height = 0;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Visibility(
          visible: provider.isShowFunDialog,
          maintainState: true,
          child: Stack(
            children: [
              GestureDetector(
                onTap: () {
                  widget.overlayEntry.remove();
                },
                behavior:
                HitTestBehavior.translucent, // 设置为translucent以便接收点击事件
              ),
              Visibility(
                  visible: height != 0,
                  maintainState: true,child:Stack(
                children: [
                  Positioned(
                      width: 200,
                      left: screenWidth - widget.x >= 200
                          ? widget.x
                          : widget.x - 200 >= 0
                          ? widget.x - 200
                          : 0,
                      top: screenHeight - widget.y >= height
                          ? widget.y
                          : widget.y - height >= 0
                          ? widget.y - height
                          : 0,
                      child:  LayoutBuilder(builder: (context,contains){
                        WidgetsBinding.instance.addPostFrameCallback((callback) {
                          if(height == 0){
                            setState(() {
                              height = context.size?.height ?? 0;
                              print("height:$height");
                            });
                          }
                        });
                        return ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: 300),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Theme.of(context).brightness == Brightness.light
                                    ? Colors.white
                                    : ThemeColors.iconColorDark,
                                border: Border.all(
                                    color:
                                    Theme.of(context).brightness == Brightness.light
                                        ? ThemeColors.iconColorLight
                                        : ThemeColors.iconColorDark,
                                    width: 1),
                                borderRadius:
                                const BorderRadius.all(Radius.circular(20))),
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if(widget.title != null) Text(widget.title ?? "",style: const TextStyle(fontSize: 15,fontWeight: FontWeight.w500),),
                                    ListView.builder(
                                      padding: const EdgeInsets.all(0),
                                      shrinkWrap: true,
                                      itemCount: widget.list.length,
                                      itemExtent: 50,
                                      physics: const BouncingScrollPhysics(),
                                      itemBuilder: (mContext, index) {
                                        var item = widget.list[index];
                                        return ListTile(
                                            title: Text(widget.initList[index],
                                                style: const TextStyle(fontSize: 15)),
                                            onTap: () {
                                              widget.onTop(item, widget.overlayEntry);
                                            });
                                      },
                                    )
                                  ],
                                )),
                          ),
                        );}
                      ))],
              )),
            ],
          ),
        ));
  }

}

class UrlOpenType{
  final bool isNowOpen;
  final String url;
  const UrlOpenType({required this.url,required this.isNowOpen});
}

Map<FunDialogType,List<HistoryInfo>> groupBy(List<HistoryInfo> infoList){
  Map<FunDialogType,List<HistoryInfo>> map = {};
  for (var element in infoList) {
    var type = checkToNowDateGap(element.time);
    if(map[type] == null){
      map[type] = [];
    }
    map[type]!.add(element);
  }
  return map;
}

List<String> findClearHistoryName(Map<FunDialogType,List<HistoryInfo>> map,BuildContext context){
  List<String> list = [];
  map.forEach((key, value) {
    switch(key){
      case FunDialogType.allTime:
        list.add(S.of(context).allTime(value.length));
        break;
      case FunDialogType.allLastSeven:
        list.add(S.of(context).allLastSeven(value.length));
        break;
      case FunDialogType.todayAndYesterday:
        list.add(S.of(context).todayAndYesterday(value.length));
        break;
      case FunDialogType.oneHour:
        list.add(S.of(context).oneHour(value.length));
        break;
      default:break;
    }
  });
  return list;
}

void showClearHistoryMenu(BuildContext context, double x, double y) {
  var provider = Provider.of<GlobalProvider>(context, listen: false);
  List<FunDialogType> list = [];
  var historyAll = provider.historyInfo.reversed.toList();
  var map = groupBy(historyAll);
  map.forEach((key, value) {
    list.add(key);
  });
  var initList = findClearHistoryName(map, context);
  showCustom(context, x, y, list, initList, provider, (item, over) async {
    provider.hideFunDialog();
    map[item]?.forEach((element) {
      provider.historyDelete(element);
    });
    over?.remove();
  },S.of(context).historyTitle);
}

void showHistoryMenu(BuildContext context, double x, double y, HistoryInfo historyInfo) {
  var provider = Provider.of<GlobalProvider>(context, listen: false);
  var list = [
    FunDialogType.openBackground,
    FunDialogType.openNew,
    FunDialogType.delete,
    FunDialogType.copyLink,
    FunDialogType.share
  ];
  var initList = _findName(list, context);
  showCustom(context, x, y, list, initList, provider, (item, over) async {
    provider.hideFunDialog();
    switch (item) {
      case FunDialogType.openBackground:
        Navigator.of(context).pop(UrlOpenType(url: historyInfo.url.toString(), isNowOpen: false));
        break;
      case FunDialogType.openNew:
        Navigator.of(context).pop(UrlOpenType(url: historyInfo.url.toString(), isNowOpen: true));
        break;
      case FunDialogType.delete:
        provider.historyDelete(historyInfo);
        break;
      case FunDialogType.copyLink:
        copyToClipboard(historyInfo.url, context);
        break;
      case FunDialogType.share:
        _shareText(historyInfo.url.toString());
        break;
      default:
        break;
    }
    over?.remove();
  });
}

void showCustomMenu(
    BuildContext context,
    double x,
    double y,
    BrowserInfo info,
    RequestFocusNodeHrefResult result,
    String title,
    String url,
    List<String> imgUrls) {
  var provider = Provider.of<GlobalProvider>(context, listen: false);
  var list = _findDialogTypeList(result);
  var initList = _findName(list, context);
  showCustom(context, x, y, list, initList, provider,
      (item, overlayEntry) async {
    provider.hideFunDialog();
    switch (item) {
      case FunDialogType.openBackground:
        info.onNewWindow(result.url.toString(), false);
        break;
      case FunDialogType.openNew:
        info.onNewWindow(result.url.toString(), true);
        break;
      case FunDialogType.viewImage:
        info.onNewWindow(result.src.toString(), true);
        break;
      case FunDialogType.saveImage:
        {
          provider.showDownloadDialog();
          var name = "${DateTime.now().millisecondsSinceEpoch}_img.png";
          var size = 0;
          if (result.src.toString().isUrl()) {
            size = await getImageSize(result.src.toString());
          } else {
            size = getBase64ImageSize(result.src.toString().splitBase64());
          }
          showDownloadDialog(
              DownloadInfo(
                  name: name,
                  url: result.src.toString(),
                  onCancel: () {
                    provider.hideDownloadDialog();
                    Navigator.of(context).pop();
                  },
                  onCopy: (url) {
                    copyToClipboard(url, context);
                  },
                  size: size,
                  onOK: (nowName) async {
                    provider.hideDownloadDialog();
                    save() async {
                      var isAndroidSdkMax34 = await onDownloadCheck();
                      onG() async {
                        await saveImageRefreshPhotoAlbum(
                            result.src ?? "", nowName, context);
                      }

                      if (Platform.isIOS) {
                        await onG();
                      } else if (isAndroidSdkMax34) {
                        await onG();
                      } else {
                        await requestStoragePermission(
                            [Permission.storage], context, onG);
                      }
                    }

                    await save();
                    Navigator.of(context).pop();
                  }),
              context,
              provider);
        }

        break;
      case FunDialogType.shareImage:
        await _shareImage(result.src ?? result.url.toString(), context);
        break;
      case FunDialogType.pictureMode:
        loadPicMode(context, imgUrls, info);
        break;
      case FunDialogType.pageInfo:
        showPageInfoDialog(
            title,
            url,
            result.url == null ? result.src.toString() : result.url.toString(),
            context);
        break;
      case FunDialogType.copyLinkText:
        copyToClipboard(result.title ?? "", context);
        break;
      case FunDialogType.scanQR:
        try {
          var name = "${DateTime.now().millisecondsSinceEpoch}_img.png";
          var path = await saveImageInLocale(
              await getApplicationDocumentsDirectory(),
              result.src.toString(),
              context,
              name);
          String? qrCodeResult;
          if (path != null) {
            qrCodeResult = await FlutterQrReader.imgScan(path);
            if (qrCodeResult.isEmpty) {
              toastMsg(S.of(context).qRNotRecognized);
            } else {
              info.onNewWindow(qrCodeResult, true);
            }
          }
        } catch (e) {
          toastMsg(S.of(context).qRNotRecognized);
        }
        break;
      case FunDialogType.copyLink:
        copyToClipboard(result.url.toString(), context);
        break;
      case FunDialogType.share:
        _shareText(result.url.toString());
        break;
      default:
        break;
    }
    overlayEntry?.remove();
  });
}

Future<int> getImageSize(String imageUrl) async {
  try {
    final response = await http.head(Uri.parse(imageUrl));
    if (response.statusCode == 200) {
      final int contentLength =
          int.parse(response.headers['content-length'] ?? '0');
      return contentLength;
    } else {
      throw Exception('Failed to load image: ${response.statusCode}');
    }
  } catch (e) {
    return 0;
  }
}

int getBase64ImageSize(String base64Image) {
  List<int> imageData = base64Decode(base64Image);
  int imageSize = imageData.length;
  return imageSize;
}

Future<bool> onDownloadCheck() async {
  if (Platform.isAndroid) {
    var androidInfo = await DeviceInfoPlugin().androidInfo;
    if (androidInfo.version.sdkInt >= 29) {
      return true;
    }
  }
  return false;
}

void loadPicMode(BuildContext context, List<String> imgUrls, BrowserInfo info) {
  var str = "";
  for (var element in imgUrls) {
    str += "<img src=\"$element\"> \n";
  }
  var htmlContent = """
             <!DOCTYPE html>
             <html lang="en">
             <head>
                  <meta charset="UTF-8">
                  <meta name="viewport" content="width=device-width, initial-scale=1.0">
                  <title>Images</title>
                   <style>
                      img {
                          display: block;
                          margin: 0 auto;
                      }
                   </style>
             </head>
             <body>$str</body>
             </html>
          """;
  debugPrint(htmlContent);
  debugPrint(htmlContent.isUrl().toString());
  info.onNewWindow(htmlContent, true);
}

///复制文字
Future<void> copyToClipboard(String text, BuildContext context) async {
  Clipboard.setData(ClipboardData(text: text));
  toastMsg(S.of(context).copiedSuccessfully);
}

///申请权限
Future<void> requestStoragePermission(List<Permission> permissions,
    BuildContext context, Function onGranted) async {
  var isGranted = true;
  for (var element in permissions) {
    if (await element.isGranted) {
      break;
    }
    PermissionStatus status = await element.request();
    if (!status.isGranted) {
      toastMsg(S.of(context).permissionNotGranted);
      return;
    }
  }
  if (isGranted) {
    onGranted();
  }
}

Future<void> saveImageRefreshPhotoAlbum(
    String url, String name, BuildContext context) async {
  var imagePath = await saveImageInLocale(
      await getDownloadsDirectory(), url, context, name);
  if (imagePath != null) {
    await GallerySaver.saveImage(imagePath);
    onG() async {
      await notificationShow("download01", "dwonloadImg",
          imagePath.split('/').last, S.of(context).downloadSuccess, (d) async {
        if (Platform.isAndroid) {
          var intent = AndroidIntent(
            action: 'action_view',
            type: 'image/png',
            data: imagePath,
            flags: [
              Flag.FLAG_ACTIVITY_NEW_TASK,
              Flag.FLAG_GRANT_READ_URI_PERMISSION
            ],
          );
          await intent.launch();
        }
        if (Platform.isIOS) {
          String url0 = "photos-redirect://";
          launchUrl(Uri.parse(url0));
        }
      });
    }

    if (Platform.isAndroid) {
      var androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt >= 34) {
        requestStoragePermission([Permission.notification], context, onG);
      } else {
        onG();
      }
    } else {
      onG;
    }
  } else {
    toastMsg(S.of(context).error);
  }
}

Future<void> notificationShow(
    String channelId,
    String channelName,
    String title,
    String body,
    DidReceiveBackgroundNotificationResponseCallback
        onClickNotification) async {
  AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    channelId, // 通知渠道的ID
    channelName, // 通知渠道的名称
    importance: Importance.max,
    priority: Priority.high,
  );
  NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
  await configureLocalNotifications(onClickNotification).show(
    1088,
    title,
    body,
    platformChannelSpecifics,
  );
}

FlutterLocalNotificationsPlugin configureLocalNotifications(
    DidReceiveBackgroundNotificationResponseCallback onClickNotification) {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('mipmap/ic_launcher');
  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onDidReceiveNotificationResponse: onClickNotification);
  return flutterLocalNotificationsPlugin;
}

void toastMsg(String msg) {
  Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: Colors.black.withOpacity(0.8),
    textColor: Colors.white,
    fontSize: 15.0,
  );
}

Future<String?> saveImageInLocale(
    Directory? dir, String url, BuildContext context, String name) async {
  try {
    var nowName = name;
    if (!name.endsWith(".png")) {
      nowName = "${DateTime.now().millisecondsSinceEpoch}_img.png";
    }
    String first = '${dir?.path}/';
    String imagePath = '$first$nowName';
    var index = 1;
    while (await File(imagePath).exists()) {
      imagePath =
          '$first${nowName.substring(0, nowName.length - 4)}(${index++}).png';
    }
    File imageFile = File(imagePath);
    List<int>? data;
    if (url.isUrl()) {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        data = response.bodyBytes;
      }
    } else {
      data = base64Decode(url.splitBase64());
    }
    if (data == null) {
      toastMsg(S.of(context).error);
      return null;
    }
    await imageFile.writeAsBytes(data);
    return imagePath;
  } catch (e) {
    toastMsg(S.of(context).error);
  }
  return null;
}

Future<void> _shareText(String text) async {
  Share.share(text);
}

//分享图片
Future<void> _shareImage(String url, BuildContext context) async {
  try {
    var path = await saveImageInLocale(await getApplicationDocumentsDirectory(),
        url, context, "${DateTime.now().millisecondsSinceEpoch}_img.png");
    if (path != null) {
      XFile xfile = XFile(path);
      // 调用share插件分享图片
      Share.shareXFiles([xfile], text: S.of(context).share);
    }
  } catch (e) {
    toastMsg(S.of(context).error);
  }
}

///downloadDialog
void showDownloadDialog(
    DownloadInfo info, BuildContext context, GlobalProvider provider) {
  showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) {
        return DownloadDialog(info: info, provider: provider);
      });
}

class DownloadDialog extends StatefulWidget {
  final DownloadInfo info;
  final GlobalProvider provider;

  const DownloadDialog({super.key, required this.info, required this.provider});

  @override
  State<StatefulWidget> createState() => DownloadDialogState();
}

class DownloadDialogState extends State<DownloadDialog> {
  late TextEditingController _controller;

  late String nameStr;

  @override
  void initState() {
    nameStr = widget.info.name;
    _controller = TextEditingController(text: nameStr);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
        visible: widget.provider.isShowDownloadDialog,
        maintainState: true,
        child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: GestureDetector(
                onTap: () {
                  widget.provider.hideDownloadDialog();
                  Navigator.of(context).pop();
                },
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    color: Colors.black45,
                    child: CustomBaseDialog(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            S.of(context).downloadDialogTitle,
                            style: const TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 15),
                          ),
                          TextField(
                              controller: _controller,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintStyle: TextStyle(fontSize: 12),
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              onChanged: (value) {
                                setState(() {
                                  nameStr = value;
                                });
                              },
                              style: const TextStyle(fontSize: 12)),
                          const Divider(height: 5, color: Colors.transparent),
                          Divider(
                              height: 2,
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? ThemeColors.secondLightColor
                                  : ThemeColors.secondDartColor),
                          const Divider(height: 5, color: Colors.transparent),
                          Row(
                            children: [
                              Text(
                                S.of(context).downloadSize,
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Theme.of(context).brightness ==
                                            Brightness.light
                                        ? ThemeColors.secondLightColor
                                        : ThemeColors.secondDartColor),
                              ),
                              Text(
                                widget.info.size.toFileSize(),
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Theme.of(context).brightness ==
                                            Brightness.light
                                        ? ThemeColors.secondLightColor
                                        : ThemeColors.secondDartColor),
                              ),
                            ],
                          ),
                          const Divider(
                            height: 20,
                            color: Colors.transparent,
                          ),
                          Row(children: [
                            GestureDetector(
                                onTap: () {
                                  widget.info.onCopy(widget.info.url);
                                },
                                child: Text(
                                  S.of(context).copyLink,
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: ThemeColors.progressStartColor),
                                )),
                            Expanded(
                              child: Container(),
                            ),
                            GestureDetector(
                                onTap: () {
                                  widget.info.onCancel();
                                },
                                child: Text(
                                  S.of(context).cancel,
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: ThemeColors.progressStartColor),
                                )),
                            const Padding(padding: EdgeInsets.only(left: 25)),
                            GestureDetector(
                              onTap: () {
                                widget.info.onOK(nameStr);
                              },
                              child: Text(
                                S.of(context).ok,
                                style: TextStyle(
                                    fontSize: 15,
                                    color: ThemeColors.progressStartColor),
                              ),
                            ),
                          ])
                        ],
                      ),
                    ),
                  ),
                ))));
  }
}

class CustomBaseDialog extends StatelessWidget {
  final Widget? child;

  const CustomBaseDialog({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Dialog(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        child: Container(
            decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.white
                    : ThemeColors.iconColorDark,
                border: Border.all(
                    color: Theme.of(context).brightness == Brightness.light
                        ? ThemeColors.iconColorLight
                        : ThemeColors.iconColorDark,
                    width: 1),
                borderRadius: const BorderRadius.all(Radius.circular(20))),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: child,
            )));
  }
}

class DownloadInfo {
  String name;
  String url;
  int size;
  Function(String) onCopy;
  Function onCancel;
  Function(String) onOK;

  DownloadInfo(
      {required this.name,
      required this.url,
      required this.onCancel,
      required this.onCopy,
      required this.size,
      required this.onOK});
}
