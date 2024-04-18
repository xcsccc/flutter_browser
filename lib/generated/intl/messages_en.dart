// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
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
  String get localeName => 'en';

  static String m0(num) => "Last 7 days(${num})";

  static String m1(num) => "All time(${num})";

  static String m2(url) => "Cookies for ${url}";

  static String m3(num) => "The last hour(${num})";

  static String m4(month, day, year, hour, minute) =>
      "${month} ${day},${year} ${hour}:${minute}";

  static String m5(weekday, month, day) => "${weekday},${month} ${day}";

  static String m6(num) => "Today and yesterday(${num})";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "aboutTitle": MessageLookupByLibrary.simpleMessage("About"),
        "addBookmark": MessageLookupByLibrary.simpleMessage("Add bookmark"),
        "allLastSeven": m0,
        "allTime": m1,
        "bookmark": MessageLookupByLibrary.simpleMessage("Bookmarks"),
        "browserFlag": MessageLookupByLibrary.simpleMessage("User-agent"),
        "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "certificate": MessageLookupByLibrary.simpleMessage("Certificate"),
        "certificateInfo":
            MessageLookupByLibrary.simpleMessage("Certificate Info"),
        "clear": MessageLookupByLibrary.simpleMessage("Clear data"),
        "code": MessageLookupByLibrary.simpleMessage("View source"),
        "commonName": MessageLookupByLibrary.simpleMessage("Common Name(CN)"),
        "commonTitle": MessageLookupByLibrary.simpleMessage("Common"),
        "cookieTitle": m2,
        "copiedSuccessfully":
            MessageLookupByLibrary.simpleMessage("Copied Successfully!"),
        "copyLink": MessageLookupByLibrary.simpleMessage("Copy link"),
        "copyLinkText": MessageLookupByLibrary.simpleMessage("Copy link text"),
        "copyText": MessageLookupByLibrary.simpleMessage("Copy text"),
        "delete": MessageLookupByLibrary.simpleMessage("delete"),
        "desktop": MessageLookupByLibrary.simpleMessage("Desktop site"),
        "dialogTitle": MessageLookupByLibrary.simpleMessage("Title:"),
        "download": MessageLookupByLibrary.simpleMessage("Downloads"),
        "downloadDialogTitle": MessageLookupByLibrary.simpleMessage(
            "Do you want to download this file?"),
        "downloadSize": MessageLookupByLibrary.simpleMessage("File size:"),
        "downloadSuccess":
            MessageLookupByLibrary.simpleMessage("download successful!"),
        "error": MessageLookupByLibrary.simpleMessage("Error"),
        "expiresOn": MessageLookupByLibrary.simpleMessage("Expires On"),
        "find": MessageLookupByLibrary.simpleMessage("Find in page"),
        "findRes": MessageLookupByLibrary.simpleMessage("Resource sniffer"),
        "fontSize": MessageLookupByLibrary.simpleMessage("Text size"),
        "full": MessageLookupByLibrary.simpleMessage("Full-screen"),
        "hide": MessageLookupByLibrary.simpleMessage("Incognito mode"),
        "history": MessageLookupByLibrary.simpleMessage("History"),
        "historyClear": MessageLookupByLibrary.simpleMessage("Delete All"),
        "historyEmpty":
            MessageLookupByLibrary.simpleMessage("History is empty!"),
        "historyTitle":
            MessageLookupByLibrary.simpleMessage("Delete history from"),
        "homeTitle": MessageLookupByLibrary.simpleMessage("Homepage"),
        "imageMode": MessageLookupByLibrary.simpleMessage("Show images"),
        "imageModes": MessageLookupByLibrary.simpleMessage(
            "Display Image,Do not display images,Display images only on WiFi"),
        "issuedBy": MessageLookupByLibrary.simpleMessage("Issued By"),
        "issuedOn": MessageLookupByLibrary.simpleMessage("Issued On"),
        "issuedTo": MessageLookupByLibrary.simpleMessage("Issued To"),
        "linkUrl": MessageLookupByLibrary.simpleMessage("Link URL:"),
        "network": MessageLookupByLibrary.simpleMessage("Network log"),
        "night": MessageLookupByLibrary.simpleMessage("Night mode"),
        "noNetworkHtml": MessageLookupByLibrary.simpleMessage("Saved page"),
        "ok": MessageLookupByLibrary.simpleMessage("OK"),
        "oneHour": m3,
        "openBg": MessageLookupByLibrary.simpleMessage("Open in background"),
        "openNew": MessageLookupByLibrary.simpleMessage("Open in new tab"),
        "organization": MessageLookupByLibrary.simpleMessage("organization(O)"),
        "organizationUnit":
            MessageLookupByLibrary.simpleMessage("Organization Unit(OU)"),
        "pageInfo": MessageLookupByLibrary.simpleMessage("Page info"),
        "pageUrl": MessageLookupByLibrary.simpleMessage("Page URL:"),
        "pdf": MessageLookupByLibrary.simpleMessage("Print/PDF"),
        "permissionNotGranted":
            MessageLookupByLibrary.simpleMessage("Permission not granted!"),
        "pictureMode": MessageLookupByLibrary.simpleMessage("Picture mode"),
        "qRNotRecognized":
            MessageLookupByLibrary.simpleMessage("QR code not recognized!"),
        "refresh": MessageLookupByLibrary.simpleMessage("Reload"),
        "save": MessageLookupByLibrary.simpleMessage("Save"),
        "saveImage": MessageLookupByLibrary.simpleMessage("Save image"),
        "scan": MessageLookupByLibrary.simpleMessage("Scan QR"),
        "scanQR": MessageLookupByLibrary.simpleMessage("Scan QR code"),
        "search": MessageLookupByLibrary.simpleMessage("search"),
        "setting": MessageLookupByLibrary.simpleMessage("Settings"),
        "share": MessageLookupByLibrary.simpleMessage("Share"),
        "shareImage": MessageLookupByLibrary.simpleMessage("Share image"),
        "timeFormat": m4,
        "timeFormatInfo": m5,
        "todayAndYesterday": m6,
        "tool": MessageLookupByLibrary.simpleMessage("Tools"),
        "translate": MessageLookupByLibrary.simpleMessage("Translate"),
        "userAgents": MessageLookupByLibrary.simpleMessage(
            "Android(Phone),Android(Tablet),Windows(Chrome),Windows(IE 11),macOS,iPhone,iPad,Symbian"),
        "validityPeriod":
            MessageLookupByLibrary.simpleMessage("VALIDITY PERIOD"),
        "viewImage": MessageLookupByLibrary.simpleMessage("View image")
      };
}
