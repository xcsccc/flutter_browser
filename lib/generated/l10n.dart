// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `search`
  String get search {
    return Intl.message(
      'search',
      name: 'search',
      desc: '',
      args: [],
    );
  }

  /// `Homepage`
  String get homeTitle {
    return Intl.message(
      'Homepage',
      name: 'homeTitle',
      desc: '',
      args: [],
    );
  }

  /// `Error`
  String get error {
    return Intl.message(
      'Error',
      name: 'error',
      desc: '',
      args: [],
    );
  }

  /// `Copied Successfully!`
  String get copiedSuccessfully {
    return Intl.message(
      'Copied Successfully!',
      name: 'copiedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Share`
  String get share {
    return Intl.message(
      'Share',
      name: 'share',
      desc: '',
      args: [],
    );
  }

  /// `Open in background`
  String get openBg {
    return Intl.message(
      'Open in background',
      name: 'openBg',
      desc: '',
      args: [],
    );
  }

  /// `Open in new tab`
  String get openNew {
    return Intl.message(
      'Open in new tab',
      name: 'openNew',
      desc: '',
      args: [],
    );
  }

  /// `View image`
  String get viewImage {
    return Intl.message(
      'View image',
      name: 'viewImage',
      desc: '',
      args: [],
    );
  }

  /// `Save image`
  String get saveImage {
    return Intl.message(
      'Save image',
      name: 'saveImage',
      desc: '',
      args: [],
    );
  }

  /// `Share image`
  String get shareImage {
    return Intl.message(
      'Share image',
      name: 'shareImage',
      desc: '',
      args: [],
    );
  }

  /// `Picture mode`
  String get pictureMode {
    return Intl.message(
      'Picture mode',
      name: 'pictureMode',
      desc: '',
      args: [],
    );
  }

  /// `Page info`
  String get pageInfo {
    return Intl.message(
      'Page info',
      name: 'pageInfo',
      desc: '',
      args: [],
    );
  }

  /// `Copy link text`
  String get copyLinkText {
    return Intl.message(
      'Copy link text',
      name: 'copyLinkText',
      desc: '',
      args: [],
    );
  }

  /// `Scan QR code`
  String get scanQR {
    return Intl.message(
      'Scan QR code',
      name: 'scanQR',
      desc: '',
      args: [],
    );
  }

  /// `Copy link`
  String get copyLink {
    return Intl.message(
      'Copy link',
      name: 'copyLink',
      desc: '',
      args: [],
    );
  }

  /// `Permission not granted!`
  String get permissionNotGranted {
    return Intl.message(
      'Permission not granted!',
      name: 'permissionNotGranted',
      desc: '',
      args: [],
    );
  }

  /// `download successful!`
  String get downloadSuccess {
    return Intl.message(
      'download successful!',
      name: 'downloadSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to download this file?`
  String get downloadDialogTitle {
    return Intl.message(
      'Do you want to download this file?',
      name: 'downloadDialogTitle',
      desc: '',
      args: [],
    );
  }

  /// `File size:`
  String get downloadSize {
    return Intl.message(
      'File size:',
      name: 'downloadSize',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get ok {
    return Intl.message(
      'OK',
      name: 'ok',
      desc: '',
      args: [],
    );
  }

  /// `QR code not recognized!`
  String get qRNotRecognized {
    return Intl.message(
      'QR code not recognized!',
      name: 'qRNotRecognized',
      desc: '',
      args: [],
    );
  }

  /// `Title:`
  String get dialogTitle {
    return Intl.message(
      'Title:',
      name: 'dialogTitle',
      desc: '',
      args: [],
    );
  }

  /// `Page URL:`
  String get pageUrl {
    return Intl.message(
      'Page URL:',
      name: 'pageUrl',
      desc: '',
      args: [],
    );
  }

  /// `Link URL:`
  String get linkUrl {
    return Intl.message(
      'Link URL:',
      name: 'linkUrl',
      desc: '',
      args: [],
    );
  }

  /// `Scan QR`
  String get scan {
    return Intl.message(
      'Scan QR',
      name: 'scan',
      desc: '',
      args: [],
    );
  }

  /// `Reload`
  String get refresh {
    return Intl.message(
      'Reload',
      name: 'refresh',
      desc: '',
      args: [],
    );
  }

  /// `Clear data`
  String get clear {
    return Intl.message(
      'Clear data',
      name: 'clear',
      desc: '',
      args: [],
    );
  }

  /// `Resource sniffer`
  String get findRes {
    return Intl.message(
      'Resource sniffer',
      name: 'findRes',
      desc: '',
      args: [],
    );
  }

  /// `Add bookmark`
  String get addBookmark {
    return Intl.message(
      'Add bookmark',
      name: 'addBookmark',
      desc: '',
      args: [],
    );
  }

  /// `Bookmarks`
  String get bookmark {
    return Intl.message(
      'Bookmarks',
      name: 'bookmark',
      desc: '',
      args: [],
    );
  }

  /// `User-agent`
  String get browserFlag {
    return Intl.message(
      'User-agent',
      name: 'browserFlag',
      desc: '',
      args: [],
    );
  }

  /// `View source`
  String get code {
    return Intl.message(
      'View source',
      name: 'code',
      desc: '',
      args: [],
    );
  }

  /// `Desktop site`
  String get desktop {
    return Intl.message(
      'Desktop site',
      name: 'desktop',
      desc: '',
      args: [],
    );
  }

  /// `Downloads`
  String get download {
    return Intl.message(
      'Downloads',
      name: 'download',
      desc: '',
      args: [],
    );
  }

  /// `Find in page`
  String get find {
    return Intl.message(
      'Find in page',
      name: 'find',
      desc: '',
      args: [],
    );
  }

  /// `Text size`
  String get fontSize {
    return Intl.message(
      'Text size',
      name: 'fontSize',
      desc: '',
      args: [],
    );
  }

  /// `Full-screen`
  String get full {
    return Intl.message(
      'Full-screen',
      name: 'full',
      desc: '',
      args: [],
    );
  }

  /// `Incognito mode`
  String get hide {
    return Intl.message(
      'Incognito mode',
      name: 'hide',
      desc: '',
      args: [],
    );
  }

  /// `History`
  String get history {
    return Intl.message(
      'History',
      name: 'history',
      desc: '',
      args: [],
    );
  }

  /// `Show images`
  String get imageMode {
    return Intl.message(
      'Show images',
      name: 'imageMode',
      desc: '',
      args: [],
    );
  }

  /// `Network log`
  String get network {
    return Intl.message(
      'Network log',
      name: 'network',
      desc: '',
      args: [],
    );
  }

  /// `Night mode`
  String get night {
    return Intl.message(
      'Night mode',
      name: 'night',
      desc: '',
      args: [],
    );
  }

  /// `Saved page`
  String get noNetworkHtml {
    return Intl.message(
      'Saved page',
      name: 'noNetworkHtml',
      desc: '',
      args: [],
    );
  }

  /// `Print/PDF`
  String get pdf {
    return Intl.message(
      'Print/PDF',
      name: 'pdf',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get setting {
    return Intl.message(
      'Settings',
      name: 'setting',
      desc: '',
      args: [],
    );
  }

  /// `Tools`
  String get tool {
    return Intl.message(
      'Tools',
      name: 'tool',
      desc: '',
      args: [],
    );
  }

  /// `Select folder`
  String get selectFolder {
    return Intl.message(
      'Select folder',
      name: 'selectFolder',
      desc: '',
      args: [],
    );
  }

  /// `New`
  String get newFolder {
    return Intl.message(
      'New',
      name: 'newFolder',
      desc: '',
      args: [],
    );
  }

  /// `Incorrect format!`
  String get msgEmpty {
    return Intl.message(
      'Incorrect format!',
      name: 'msgEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Title`
  String get title {
    return Intl.message(
      'Title',
      name: 'title',
      desc: '',
      args: [],
    );
  }

  /// `Url`
  String get url {
    return Intl.message(
      'Url',
      name: 'url',
      desc: '',
      args: [],
    );
  }

  /// `add to homepage`
  String get addHomepage {
    return Intl.message(
      'add to homepage',
      name: 'addHomepage',
      desc: '',
      args: [],
    );
  }

  /// `Translate`
  String get translate {
    return Intl.message(
      'Translate',
      name: 'translate',
      desc: '',
      args: [],
    );
  }

  /// `Certificate`
  String get certificate {
    return Intl.message(
      'Certificate',
      name: 'certificate',
      desc: '',
      args: [],
    );
  }

  /// `Certificate Info`
  String get certificateInfo {
    return Intl.message(
      'Certificate Info',
      name: 'certificateInfo',
      desc: '',
      args: [],
    );
  }

  /// `Issued To`
  String get issuedTo {
    return Intl.message(
      'Issued To',
      name: 'issuedTo',
      desc: '',
      args: [],
    );
  }

  /// `Common Name(CN)`
  String get commonName {
    return Intl.message(
      'Common Name(CN)',
      name: 'commonName',
      desc: '',
      args: [],
    );
  }

  /// `organization(O)`
  String get organization {
    return Intl.message(
      'organization(O)',
      name: 'organization',
      desc: '',
      args: [],
    );
  }

  /// `Organization Unit(OU)`
  String get organizationUnit {
    return Intl.message(
      'Organization Unit(OU)',
      name: 'organizationUnit',
      desc: '',
      args: [],
    );
  }

  /// `Issued By`
  String get issuedBy {
    return Intl.message(
      'Issued By',
      name: 'issuedBy',
      desc: '',
      args: [],
    );
  }

  /// `VALIDITY PERIOD`
  String get validityPeriod {
    return Intl.message(
      'VALIDITY PERIOD',
      name: 'validityPeriod',
      desc: '',
      args: [],
    );
  }

  /// `Issued On`
  String get issuedOn {
    return Intl.message(
      'Issued On',
      name: 'issuedOn',
      desc: '',
      args: [],
    );
  }

  /// `Expires On`
  String get expiresOn {
    return Intl.message(
      'Expires On',
      name: 'expiresOn',
      desc: '',
      args: [],
    );
  }

  /// `Cookies for {url}`
  String cookieTitle(Object url) {
    return Intl.message(
      'Cookies for $url',
      name: 'cookieTitle',
      desc: '',
      args: [url],
    );
  }

  /// `Copy text`
  String get copyText {
    return Intl.message(
      'Copy text',
      name: 'copyText',
      desc: '',
      args: [],
    );
  }

  /// `delete`
  String get delete {
    return Intl.message(
      'delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `Delete history from`
  String get historyTitle {
    return Intl.message(
      'Delete history from',
      name: 'historyTitle',
      desc: '',
      args: [],
    );
  }

  /// `Delete All`
  String get historyClear {
    return Intl.message(
      'Delete All',
      name: 'historyClear',
      desc: '',
      args: [],
    );
  }

  /// `All time({num})`
  String allTime(Object num) {
    return Intl.message(
      'All time($num)',
      name: 'allTime',
      desc: '',
      args: [num],
    );
  }

  /// `Last 7 days({num})`
  String allLastSeven(Object num) {
    return Intl.message(
      'Last 7 days($num)',
      name: 'allLastSeven',
      desc: '',
      args: [num],
    );
  }

  /// `Today and yesterday({num})`
  String todayAndYesterday(Object num) {
    return Intl.message(
      'Today and yesterday($num)',
      name: 'todayAndYesterday',
      desc: '',
      args: [num],
    );
  }

  /// `The last hour({num})`
  String oneHour(Object num) {
    return Intl.message(
      'The last hour($num)',
      name: 'oneHour',
      desc: '',
      args: [num],
    );
  }

  /// `History is empty!`
  String get historyEmpty {
    return Intl.message(
      'History is empty!',
      name: 'historyEmpty',
      desc: '',
      args: [],
    );
  }

  /// `{weekday},{month} {day}`
  String timeFormatInfo(Object weekday, Object month, Object day) {
    return Intl.message(
      '$weekday,$month $day',
      name: 'timeFormatInfo',
      desc: '',
      args: [weekday, month, day],
    );
  }

  /// `{month} {day},{year} {hour}:{minute}`
  String timeFormat(
      Object month, Object day, Object year, Object hour, Object minute) {
    return Intl.message(
      '$month $day,$year $hour:$minute',
      name: 'timeFormat',
      desc: '',
      args: [month, day, year, hour, minute],
    );
  }

  /// `Android(Phone),Android(Tablet),Windows(Chrome),Windows(IE 11),macOS,iPhone,iPad,Symbian`
  String get userAgents {
    return Intl.message(
      'Android(Phone),Android(Tablet),Windows(Chrome),Windows(IE 11),macOS,iPhone,iPad,Symbian',
      name: 'userAgents',
      desc: '',
      args: [],
    );
  }

  /// `Display Image,Do not display images,Display images only on WiFi`
  String get imageModes {
    return Intl.message(
      'Display Image,Do not display images,Display images only on WiFi',
      name: 'imageModes',
      desc: '',
      args: [],
    );
  }

  /// `About`
  String get aboutTitle {
    return Intl.message(
      'About',
      name: 'aboutTitle',
      desc: '',
      args: [],
    );
  }

  /// `Common`
  String get commonTitle {
    return Intl.message(
      'Common',
      name: 'commonTitle',
      desc: '',
      args: [],
    );
  }

  String get clearMode {
    return Intl.message(
      'Cache,Form Data,History,Web Storage,Cookies,Application Cache',
      name: 'clearMode',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'zh'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
