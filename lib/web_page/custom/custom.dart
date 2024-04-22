import 'package:browser01/web_page/provider/main_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../generated/l10n.dart';
import '../dialog/long_click_dialog.dart';

const String homeUrl = "assets/home.html";

///拓展函数写法
extension StringExtension on String {
  bool isUrl() {
    final RegExp urlRegex = RegExp(
        r'^(?:https?://)?(?:www\.)?[a-zA-Z0-9-]+(?:\.[a-zA-Z]{2,})+(?:[/?].*)?$');
    return urlRegex.hasMatch(this);
  }

  String completeUrl() {
    if (startsWith("http://") || startsWith("https://")) {
      return this;
    } else {
      return "https://$this";
    }
  }

  bool isBase64() {
    return startsWith("data:");
  }

  String splitBase64() {
    return split(',').last;
  }

  String toNowString() {
    return this;
  }

  List<String> splitToRich() {
    if (isEmpty || !isUrl()) {
      return [this];
    } else {
      Uri uri = Uri.parse(this);
      String protocol = uri.scheme;
      String domain = uri.host;
      return [
        protocol,
        "://",
        domain,
        substring(protocol.length + 3 + domain.length, length)
      ];
    }
  }

  String isEmptyToStr() {
    return isEmpty ? "-" : this;
  }

  bool isImageUrl() {
    return toLowerCase().endsWith(".png") ||
        toLowerCase().endsWith(".jpg") ||
        toLowerCase().endsWith(".jpeg") ||
        toLowerCase().endsWith(".gif") ||
        toLowerCase().endsWith(".svg");
  }

  String extractSearchKeyword() {
    for (var entry in searchEngineParams.entries) {
      var key = entry.key;
      var value = entry.value;
      if (contains(key)) {
        var pattern = RegExp("[?&]$value=([^&]+)");
        var matcher = pattern.firstMatch(this);
        if (matcher != null) {
          return matcher.group(1) ?? this;
        }
        break;
      }
    }
    return this;
  }

  String? iconUrl() {
    try {
      return "${extractDomainWithProtocol()}/favicon.ico";
    } catch (e) {
      return null;
    }
  }

  String? extractDomainWithProtocol() {
    try {
      Uri uri = Uri.parse(this);
      String protocol = uri.scheme;
      String domain = uri.host;
      if (protocol.isNotEmpty && domain.isNotEmpty) {
        return '$protocol://$domain';
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}

Map<String, String> searchEngineParams = {
  "www.google.": "q",
  "www.baidu.": "wd",
  "www.bing.": "q",
  "search.yahoo.": "p",
  "www.startpage.": "query",
  "duckduckgo.com": "q"
};

const String settingCommonKey = "settingCommonKey";
const String funcBottomKey = "funcBottomKey";
const String historyInfoKey = "historyInfoKey";
const String bookmarkInfoKey = "bookmarkInfoKey";
const String treeNodeKey = "treeNodeKey";
const String treeNodeInfoKey = "treeNodeInfoKey";
const String localeChangeKey = "localeChangeKey";
const String intKey = "intKey";

const String boolKey = "boolKey";
const String nightModeKey = "nightModeKey";
// const String addBookmarkKey = "addBookmarkKey";
const String desktopKey = "desktopKey";
const String hideKey = "hideKey";
const String browserFlagKey = "browserFlagKey";
const String fullKey = "fullKey";
const String searchEnginKey = "searchEnginKey";
const String imageModeKey = "imageModeKey";
const String forceDarkKey = "forceDarkKey";

extension LongExt on int {
  String toFileSize() {
    const units = ['B', 'KB', 'MB', 'GB', 'TB'];
    int i = 0;
    double result = toDouble();
    while (result >= 1024 && i < units.length - 1) {
      result /= 1024;
      i++;
    }
    return '${result.toStringAsFixed(2)} ${units[i]}';
  }

  String formatTime(BuildContext context) {
    var provider = Provider.of<GlobalProvider>(context, listen: false);
    DateTime dateTimeMilliseconds = DateTime.fromMillisecondsSinceEpoch(this);
    var weekday = dateTimeMilliseconds.weekday;
    var month = dateTimeMilliseconds.month;
    var day = dateTimeMilliseconds.day;
    if (provider.locale.languageCode == "zh") {
      return S.of(context).timeFormatInfo(_weekZh(weekday), month, day);
    } else {
      return S
          .of(context)
          .timeFormatInfo(_weekEn(weekday), _monthEn(month), day);
    }
  }

  String _monthEn(int day) {
    switch (day) {
      case 1:
        return "Jan";
      case 2:
        return "Feb";
      case 3:
        return "Mar";
      case 4:
        return "Apr";
      case 5:
        return "May";
      case 6:
        return "Jun";
      case 7:
        return "Jul";
      case 8:
        return "Aug";
      case 9:
        return "Sep";
      case 10:
        return "Oct";
      case 11:
        return "Nov";
      case 12:
        return "Dec";
    }
    return "";
  }

  String _weekZh(int day) {
    switch (day) {
      case 1:
        return "周一";
      case 2:
        return "周二";
      case 3:
        return "周三";
      case 4:
        return "周四";
      case 5:
        return "周五";
      case 6:
        return "周六";
      case 7:
        return "周日";
    }
    return "";
  }

  String _weekEn(int day) {
    switch (day) {
      case 1:
        return "Mon";
      case 2:
        return "Tue";
      case 3:
        return "Wed";
      case 4:
        return "Thu";
      case 5:
        return "Fri";
      case 6:
        return "Sat";
      case 7:
        return "Sun";
    }
    return "";
  }
}

enum DateGapDay { all, sevenDay, oneDay, oneHour }

extension DataTimeExt on DateTime {
  String formatTime(BuildContext context) {
    return S.of(context).timeFormat(month, day, year, hour, minute);
  }
}

FunDialogType checkToNowDateGap(int m) {
  var other = DateTime.fromMillisecondsSinceEpoch(m);
  var now = DateTime.now();
  Duration difference = now.difference(other).abs();
  if (difference.inHours <= 1) {
    return FunDialogType.oneHour;
  } else if (difference.inDays <= 1) {
    return FunDialogType.todayAndYesterday;
  } else if (difference.inDays <= 7) {
    return FunDialogType.allLastSeven;
  } else {
    return FunDialogType.allTime;
  }
}

class RouteSetting {
  static const String mainPage = '/';
  static const String scannerPage = '/scanner';
  static const String bookmarkHistorySavePage = '/bookmark_history_save';
  static const String settings = '/settings';
  static const String aboutPage = '/aboutPage';
  static const String openSource = '/openSource';
  static const String settingsCommon = '/settingsCommon';
  static const String userAgentSetting = '/userAgentSetting';
  static const String darkMode = '/darkMode';
}

enum FuncBottomType {
  night,
  bookmark,
  history,
  download,
  hide,
  share,
  addBookmark,
  desktop,
  tool,
  setting,
  find,
  save,
  translate,
  code,
  full,
  imageMode,
  browserFlag,
  refresh,
  network,
  findRes,
  noNetworkHtml,
  scan,
  fontSize,
  clear,
  pdf
}

enum UserAgentType {
  androidAgent(
      "Mozilla/5.0 (Linux; Android 12; Pixel 2 Build/SQ1D.220205.004; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/91.0.4472.114 Mobile Safari/537.36"),
  androidTablet(
      "Mozilla/5.0 (Linux; Android 10.0.0; Nexus 10 Build/OPR1.170623.027) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4324.152 Safari/537.36"),
  windowChrome(
      "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/98.0.4758.102 Safari/537.36"),
  windowIE(
      "Mozilla/5.0 (Windows NT 10.0; WOW64; Trident/7.0; rv:11.0) like Gecko"),
  macos(
      "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Safari/605.1.15"),
  iphone(
      "Mozilla/5.0 (iPhone; CPU iPhone OS 14_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.0 Mobile/15E148 Safari/604.1"),
  ipad(
      "Mozilla/5.0 (iPad; CPU OS 14_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.0 Mobile/15E148 Safari/604.1"),
  symbian(
      "Mozilla/5.0 (SymbianOS/9.4; U; Series60/5.0 Nokia5800d-1/60.0.003; Profile/MIDP-2.1 Configuration/CLDC-1.1 ) AppleWebKit/413 (KHTML, like Gecko) Safari/413");

  final String userAgent;

  const UserAgentType(this.userAgent);
}

enum SearchEnginType {
  google("https://www.google.com/search?q=", "Google"),
  baidu("https://www.baidu.com/s?wd=", "Baidu"),
  bing("https://www.bing.com/search?q=", "Bing"),
  yahoo("https://search.yahoo.com/search?p=", "Yahoo");

  final String enginName;
  final String enginUrl;

  const SearchEnginType(this.enginUrl, this.enginName);
}

enum ImageModeType {
  display("Display Image"),
  noDisplay("Do not display images"),
  displayOnWifi("Display images only on WiFi");

  final String modeDesc;

  const ImageModeType(this.modeDesc);
}

List<String> sourceList = [
  "flutter_inappwebview",
  "cached_network_image",
  "hive",
  "provider",
  "hive_flutter",
  "intl",
  "flutter_phoenix",
  "permission_handler",
  "share_plus",
  "gallery_saver",
  "path_provider",
  "http",
  "fluttertoast",
  "flutter_local_notifications",
  "android_intent_plus",
  "url_launcher",
  "device_info_plus",
  "flutter_qr_reader",
  "ai_barcode_scanner",
  "image_picker",
  "expandable_page_view",
  "marquee",
  "cupertino_icons",
  "connectivity"
];

enum ClearDataType {
  cache("Cache"),
  form("Form Data"),
  history("History"),
  webStorage("Web Storage"),
  cookie("Cookies"),
  appCache("Application Cache");

  final String clearName;

  const ClearDataType(this.clearName);
}
