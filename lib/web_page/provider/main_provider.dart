import 'dart:io';

import 'package:browser01/web_page/custom/custom.dart';
import 'package:browser01/web_page/dialog/user_agent_dialog.dart';
import 'package:browser01/web_page/model/history_info.dart';
import 'package:browser01/web_page/model/setting_common_info.dart';
import 'package:connectivity/connectivity.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:hive/hive.dart';

import '../custom/func_bottom_info.dart';
import '../model/tree_node.dart';
import '../web_main_page.dart';

class GlobalProvider with ChangeNotifier {
  int selectLocale = 0;
  final List<Locale> _listLocale = [const Locale("en", ""), const Locale("zh", "")];
  bool isShowFunDialog = true;
  bool isShowDownloadDialog = true;
  int selectPosition = 0;
  List<GlobalKey<BrowserState>> browserKey = [];
  late bool forceDark = Hive.box(boolKey).get(forceDarkKey, defaultValue: false);
  late ThemeData currentTheme =
      Hive.box(boolKey).get(nightModeKey, defaultValue: false) ? ThemeData.dark() : ThemeData.light();
  FuncBottomType nowClickType = FuncBottomType.night;
  late String? userAgent = Hive.box(boolKey).get(desktopKey, defaultValue: false)
      ? UserAgentType.windowChrome.userAgent
      : UserAgentType.androidAgent.userAgent;
  UserAgentType? nowType;
  ImageModeType? modeType;
  late SearchEnginType selectEngin = SearchEnginType.values[Hive.box(intKey).get(searchEnginKey, defaultValue: 0)];
  late InAppWebViewSettings settings = updateSettings();
  late int maskAlpha = Hive.box(intKey).get(maskAlphaKey, defaultValue: 40);

  BrowserState? getPageNowState() => browserKey[selectPosition].currentState;

  InAppWebViewController? getNowControl() => getPageNowState()?.control;

  List<HistoryInfo> get historyInfo => HistoryInfo.getAll().reversed.toList();

  late TreeNode treeNodeInfo = TreeNode.get();

  //递归删除
  TreeNode? removeTreeNode(TreeNode parent,TreeNode removeInfo,TreeNode now){
    if(now == parent){
      now.children.remove(removeInfo);
      treeNodeInfo.put();
      return now;
    }else{
      for (var element in now.children) {
       return removeTreeNode(parent, removeInfo,element);
      }
    }
  }

  List<SettingCommonInfo> get settingCommonInfo => SettingCommonInfo.getAll().toList();

  List<FuncBottomInfo> getFuncBottomInfoList(List<FuncBottomInfo> init) {
    var list = FuncBottomInfo.getAll();
    if (list.isEmpty) {
      FuncBottomInfo.openBox().addAll(init);
      list = init;
    }
    return list;
  }

  void setSelectPositionPage(int pagePosition) {
    selectPosition = pagePosition;
    notifyListeners();
  }

  List<SettingCommonInfo> getSettingCommonInfoList(List<SettingCommonInfo> init) {
    var list = SettingCommonInfo.getAll();
    if (list.isEmpty) {
      SettingCommonInfo.openBox().addAll(init);
      list = init;
    }
    return list;
  }

  void historyDelete(HistoryInfo history) {
    history.delete();
    notifyListeners();
  }

  InAppWebViewSettings updateSettings() {
    print("${currentTheme == ThemeData.light() && !forceDark} force dark");
    return InAppWebViewSettings(
        javaScriptEnabled: true,
        useOnDownloadStart: true,
        supportZoom: true,
        enableViewportScale: true,
        userAgent: userAgent,
        forceDark: (currentTheme == ThemeData.dark() && forceDark) ? ForceDark.ON : ForceDark.OFF,
        forceDarkStrategy: ForceDarkStrategy.USER_AGENT_DARKENING_ONLY,
        verticalScrollBarEnabled: false,
        horizontalScrollBarEnabled: false,
        javaScriptCanOpenWindowsAutomatically: true,
        supportMultipleWindows: true,
        blockNetworkImage: false);
  }

  void changeAllSetting() {
    for (var element in browserKey) {
      element.currentState?.control?.setSettings(settings: settings);
    }
  }

  void changeSearchEngin(SearchEnginType type) {
    selectEngin = type;
    notifyListeners();
  }

  void changeSearchEnginSetting(SearchEnginType type) {
    selectEngin = type;
    settingCommonInfo[6].desc = type.enginName;
    settingCommonInfo[6].edit(6);
    notifyListeners();
  }

  void updateUserAgent(UserAgentType type) {
    nowType = type;
    userAgent = type.userAgent;
    settings = updateSettings();
    changeAllSetting();
    for (var element in browserKey) {
      element.currentState?.control?.reload();
    }
    notifyListeners();
  }

  void updateUserAgentSetting(UserAgentInfo info, int index) {
    nowType = info.type;
    userAgent = info.type.userAgent;
    settings = updateSettings();
    changeAllSetting();
    for (var element in browserKey) {
      element.currentState?.control?.reload();
    }
    settingCommonInfo[index].desc = info.name;
    settingCommonInfo[index].edit(index);
    notifyListeners();
  }

  void updateForceDark(bool isForceDark) {
    forceDark = isForceDark;
    settings = updateSettings();
    changeAllSetting();
    notifyListeners();
  }

  void updateMaskAlpha(int alpha) {
    maskAlpha = alpha;
    notifyListeners();
  }

  Future<void> updateImageMode(ImageModeType type) async {
    modeType = type;
    settings = updateSettings();
    if (modeType == ImageModeType.display) {
      settings.blockNetworkImage = false;
    } else if (modeType == ImageModeType.noDisplay) {
      settings.blockNetworkImage = true;
    } else {
      var connectivityResult = await Connectivity().checkConnectivity();
      settings.blockNetworkImage = connectivityResult != ConnectivityResult.wifi;
    }
    changeAllSetting();
    for (var element in browserKey) {
      element.currentState?.control?.reload();
    }
    notifyListeners();
  }

  void desktopChange(bool isOpen) {
    if (isOpen) {
      userAgent = UserAgentType.windowChrome.userAgent;
    } else {
      if (nowType != null) {
        userAgent = nowType!.userAgent;
      } else {
        userAgent = UserAgentType.androidAgent.userAgent;
      }
    }
    settings = updateSettings();
    changeAllSetting();
    for (var element in browserKey) {
      element.currentState?.control?.reload();
    }
    notifyListeners();
  }

  void setFuncBottomTypeOnChange(FuncBottomType type) {
    nowClickType = type;
    notifyListeners();
  }

  void toggleTheme() async {
    currentTheme = currentTheme == ThemeData.light() ? ThemeData.dark() : ThemeData.light();
    settings = updateSettings();
    changeAllSetting();
    if (Platform.isAndroid) {
      var androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt > 32) {
        for (var element in browserKey) {
          element.currentState?.control?.reload();
        }
      }
    }
    notifyListeners();
  }

  late var locale = _listLocale[Hive.box(intKey).get(localeChangeKey, defaultValue: 0)!];

  void hideFunDialog() {
    isShowFunDialog = false;
    notifyListeners();
  }

  void showFunDialog() {
    isShowFunDialog = true;
    notifyListeners();
  }

  void hideDownloadDialog() {
    isShowDownloadDialog = false;
    notifyListeners();
  }

  void showDownloadDialog() {
    isShowDownloadDialog = true;
    notifyListeners();
  }

  void updateLocale(Function onFinish) async {
    if (selectLocale != _listLocale.length - 1) {
      selectLocale += 1;
      locale = _listLocale[selectLocale];
    } else {
      selectLocale = 0;
      locale = _listLocale[selectLocale];
    }
    await Hive.box(intKey).put(localeChangeKey, selectLocale);
    onFinish();
    notifyListeners();
  }
}
