// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a zh locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'zh';

  static String m0(num) => "过去7天(${num})";

  static String m1(num) => "所有时间(${num})";

  static String m2(url) => "${url} 的 Cookies";

  static String m3(deleteNum) =>
      "${Intl.plural(deleteNum, zero: '删除', one: '删除(${deleteNum})', other: '删除(${deleteNum})')}";

  static String m4(num) => "过去一小时(${num})";

  static String m5(month, day, year, hour, minute) =>
      "${year}年${month}月${day}日 ${hour}:${minute}";

  static String m6(weekday, month, day) => "${month}月${day}日 ${weekday}";

  static String m7(num) => "今天和昨天(${num})";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "aboutTitle": MessageLookupByLibrary.simpleMessage("关于"),
        "addBookmark": MessageLookupByLibrary.simpleMessage("添加书签"),
        "addHomepage": MessageLookupByLibrary.simpleMessage("添加到主页"),
        "allLastSeven": m0,
        "allTime": m1,
        "bookmark": MessageLookupByLibrary.simpleMessage("书签"),
        "browserFlag": MessageLookupByLibrary.simpleMessage("浏览器标识"),
        "cancel": MessageLookupByLibrary.simpleMessage("取消"),
        "cancelAll": MessageLookupByLibrary.simpleMessage("取消全选"),
        "certificate": MessageLookupByLibrary.simpleMessage("查看证书"),
        "certificateInfo": MessageLookupByLibrary.simpleMessage("证书信息"),
        "clear": MessageLookupByLibrary.simpleMessage("清除数据"),
        "clearMode": MessageLookupByLibrary.simpleMessage(
            "缓存,表格数据,历史记录,网页存储,Cookies,应用缓存"),
        "code": MessageLookupByLibrary.simpleMessage("源码"),
        "commonName": MessageLookupByLibrary.simpleMessage("公用名（CN）"),
        "commonTitle": MessageLookupByLibrary.simpleMessage("通用"),
        "cookieTitle": m2,
        "copiedSuccessfully": MessageLookupByLibrary.simpleMessage("复制成功！"),
        "copyLink": MessageLookupByLibrary.simpleMessage("复制链接"),
        "copyLinkText": MessageLookupByLibrary.simpleMessage("复制链接文本"),
        "copyText": MessageLookupByLibrary.simpleMessage("复制文本"),
        "delete": MessageLookupByLibrary.simpleMessage("删除"),
        "deleteTwo": m3,
        "desktop": MessageLookupByLibrary.simpleMessage("电脑模式"),
        "dialogTitle": MessageLookupByLibrary.simpleMessage("标题:"),
        "done": MessageLookupByLibrary.simpleMessage("完成"),
        "download": MessageLookupByLibrary.simpleMessage("下载"),
        "downloadDialogTitle":
            MessageLookupByLibrary.simpleMessage("你想要下载此文件吗？"),
        "downloadSize": MessageLookupByLibrary.simpleMessage("文件大小:"),
        "downloadSuccess": MessageLookupByLibrary.simpleMessage("下载成功！"),
        "edit": MessageLookupByLibrary.simpleMessage("修改"),
        "error": MessageLookupByLibrary.simpleMessage("错误"),
        "expiresOn": MessageLookupByLibrary.simpleMessage("截止日期"),
        "find": MessageLookupByLibrary.simpleMessage("页内查找"),
        "findRes": MessageLookupByLibrary.simpleMessage("资源嗅探"),
        "fontSize": MessageLookupByLibrary.simpleMessage("字体大小"),
        "full": MessageLookupByLibrary.simpleMessage("全屏"),
        "hide": MessageLookupByLibrary.simpleMessage("隐身"),
        "history": MessageLookupByLibrary.simpleMessage("历史"),
        "historyClear": MessageLookupByLibrary.simpleMessage("清空"),
        "historyEmpty": MessageLookupByLibrary.simpleMessage("历史记录为空！"),
        "historyTitle": MessageLookupByLibrary.simpleMessage("清空历史记录"),
        "homeTitle": MessageLookupByLibrary.simpleMessage("主页"),
        "imageMode": MessageLookupByLibrary.simpleMessage("有图模式"),
        "imageModes": MessageLookupByLibrary.simpleMessage(
            "Display Image,Do not display images,Display images only on WiFi"),
        "issuedBy": MessageLookupByLibrary.simpleMessage("颁发者"),
        "issuedOn": MessageLookupByLibrary.simpleMessage("颁发日期"),
        "issuedTo": MessageLookupByLibrary.simpleMessage("颁发对象"),
        "linkUrl": MessageLookupByLibrary.simpleMessage("选中链接:"),
        "maskFilter": MessageLookupByLibrary.simpleMessage("网页遮罩"),
        "more": MessageLookupByLibrary.simpleMessage("更多"),
        "move": MessageLookupByLibrary.simpleMessage("移动"),
        "msgEmpty": MessageLookupByLibrary.simpleMessage("格式不正确!"),
        "network": MessageLookupByLibrary.simpleMessage("网络日志"),
        "newFolder": MessageLookupByLibrary.simpleMessage("新建"),
        "newFolderTwo": MessageLookupByLibrary.simpleMessage("新建文件夹"),
        "night": MessageLookupByLibrary.simpleMessage("夜间模式"),
        "noNetworkHtml": MessageLookupByLibrary.simpleMessage("离线页面"),
        "ok": MessageLookupByLibrary.simpleMessage("确定"),
        "oneHour": m4,
        "openBg": MessageLookupByLibrary.simpleMessage("后台打开"),
        "openNew": MessageLookupByLibrary.simpleMessage("新标签打开"),
        "organization": MessageLookupByLibrary.simpleMessage("组织（O）"),
        "organizationUnit": MessageLookupByLibrary.simpleMessage("组织单位（OU）"),
        "pageInfo": MessageLookupByLibrary.simpleMessage("页面信息"),
        "pageUrl": MessageLookupByLibrary.simpleMessage("页面链接:"),
        "pdf": MessageLookupByLibrary.simpleMessage("打印/PDF"),
        "permissionNotGranted": MessageLookupByLibrary.simpleMessage("未授予权限！"),
        "pictureMode": MessageLookupByLibrary.simpleMessage("看图模式"),
        "qRNotRecognized": MessageLookupByLibrary.simpleMessage("未识别到二维码！"),
        "refresh": MessageLookupByLibrary.simpleMessage("刷新网页"),
        "save": MessageLookupByLibrary.simpleMessage("保存"),
        "saveImage": MessageLookupByLibrary.simpleMessage("保存图片"),
        "scan": MessageLookupByLibrary.simpleMessage("扫描二维码"),
        "scanQR": MessageLookupByLibrary.simpleMessage("扫描二维码"),
        "search": MessageLookupByLibrary.simpleMessage("搜索"),
        "selectAll": MessageLookupByLibrary.simpleMessage("全选"),
        "selectFolder": MessageLookupByLibrary.simpleMessage("选择文件夹"),
        "setting": MessageLookupByLibrary.simpleMessage("设置"),
        "share": MessageLookupByLibrary.simpleMessage("分享"),
        "shareImage": MessageLookupByLibrary.simpleMessage("分享图片"),
        "timeFormat": m5,
        "timeFormatInfo": m6,
        "title": MessageLookupByLibrary.simpleMessage("标题"),
        "todayAndYesterday": m7,
        "tool": MessageLookupByLibrary.simpleMessage("工具箱"),
        "translate": MessageLookupByLibrary.simpleMessage("翻译"),
        "url": MessageLookupByLibrary.simpleMessage("链接"),
        "userAgents": MessageLookupByLibrary.simpleMessage(
            "Android(手机),Android(平板),Windows(Chrome),Windows(IE 11),macOS,iPhone,iPad,塞班(Symbian)"),
        "validityPeriod": MessageLookupByLibrary.simpleMessage("有效期"),
        "viewImage": MessageLookupByLibrary.simpleMessage("查看图片")
      };
}
