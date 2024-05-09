import 'package:browser01/web_page/back/back_click.dart';
import 'package:browser01/web_page/bar/bottom_tool_bar.dart';
import 'package:browser01/web_page/color/colors.dart';
import 'package:browser01/web_page/custom/FuncBottomInfo.g.dart';
import 'package:browser01/web_page/custom/custom.dart';
import 'package:browser01/web_page/bar/top_search_bar.dart';
import 'package:browser01/web_page/bar/top_title_bar.dart';
import 'package:browser01/web_page/custom/func_bottom_info.dart';
import 'package:browser01/web_page/dialog/add_bookmark.dart';
import 'package:browser01/web_page/dialog/func_dialog.dart';
import 'package:browser01/web_page/dialog/image_mode_dialog.dart';
import 'package:browser01/web_page/dialog/long_click_dialog.dart';
import 'package:browser01/web_page/dialog/user_agent_dialog.dart';
import 'package:browser01/web_page/main_view/progress_bar.dart';
import 'package:browser01/web_page/main_view/view.dart';
import 'package:browser01/web_page/model/BookmarkInfo.g.dart';
import 'package:browser01/web_page/model/FileType.g.dart';
import 'package:browser01/web_page/model/HistoryInfo.g.dart';
import 'package:browser01/web_page/model/SearchInfo.dart';
import 'package:browser01/web_page/model/SettingCommon.g.dart';
import 'package:browser01/web_page/model/bookmark_info.dart';
import 'package:browser01/web_page/model/history_info.dart';
import 'package:browser01/web_page/model/setting_common_info.dart';
import 'package:browser01/web_page/model/tree_node.dart';
import 'package:browser01/web_page/page/AboutPage.dart';
import 'package:browser01/web_page/page/DarkModePage.dart';
import 'package:browser01/web_page/page/OpenSourcePage.dart';
import 'package:browser01/web_page/page/SettingCommonPage.dart';
import 'package:browser01/web_page/page/UserAgentSettingPage.dart';
import 'package:browser01/web_page/page/bookmark_history_save_page.dart';
import 'package:browser01/web_page/page/new_folder_page.dart';
import 'package:browser01/web_page/page/scanner_page.dart';
import 'package:browser01/web_page/page/SettingPage.dart';
import 'package:browser01/web_page/provider/main_provider.dart';
import 'package:browser01/web_page/web_main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'generated/l10n.dart';
import 'package:browser01/web_page/model/ClearDataExitInfo.g.dart';
import 'package:browser01/web_page/model/clear_data_exit_info.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';


void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(SettingCommonAdapter());
  Hive.registerAdapter(FuncBottomInfoAdapter());
  Hive.registerAdapter(HistoryInfoAdapter());
  Hive.registerAdapter(BookmarkInfoAdapter());
  Hive.registerAdapter(TreeNodeAdapter());
  Hive.registerAdapter(FileTypeAdapter());
  Hive.registerAdapter(ClearDataExitAdapter());
  await Hive.openBox<ClearDataExitInfo>(clearDataExitInfoKey);
  await Hive.openBox<FuncBottomInfo>(funcBottomKey);
  await Hive.openBox<HistoryInfo>(historyInfoKey);
  await Hive.openBox<TreeNode>(treeNodeKey);
  await Hive.openBox<SettingCommonInfo>(settingCommonKey);
  await Hive.openBox(intKey);
  await Hive.openBox(boolKey);
  runApp(ChangeNotifierProvider<GlobalProvider>(
    create: (context) => GlobalProvider(),
    child: Phoenix(
      child: const MyApp(),
    ),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() {
    print('hello');
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> with WidgetsBindingObserver {
  late var provider = Provider.of<GlobalProvider>(context);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.detached) {
      print(provider.clearDataExitInfo.toString());
      for (int i = 0; i < provider.clearDataExitInfo.length; i++) {
        var element = provider.clearDataExitInfo[i];
        var control = provider.getNowControl();
        if (element.isSelect) {
          switch (i) {
            case 1:
              control?.clearFormData();
              break;
            case 2:
              HistoryInfo.openBox().clear();
              control?.clearHistory();
              break;
            case 3:
              InAppWebViewController.clearAllCache();
              CookieManager.instance().deleteAllCookies();
              break;
            case 4:
              CookieManager.instance().deleteAllCookies();
              break;
            case 5:
              Directory appCacheDir = getTemporaryDirectory() as Directory;
              String appCachePath = appCacheDir.path;
              try {
                Directory(appCachePath).delete(recursive: true);
                print('App cache cleared.');
              } catch (e) {
                print('Failed to clear app cache: $e');
              }
              break;
            default:
              InAppWebViewController.clearAllCache();
              break;
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: RouteSetting.mainPage,
      routes: {
        RouteSetting.mainPage: (context) => const MyHomePage(),
        RouteSetting.scannerPage: (context) => const ScannerPage(),
        RouteSetting.bookmarkHistorySavePage: (context) => const BookmarkAndHistoryAndSavePage(),
        RouteSetting.settings: (context) => const SettingPage(),
        RouteSetting.aboutPage: (context) => const AboutPage(),
        RouteSetting.openSource: (context) => const OpenSourcePage(),
        RouteSetting.settingsCommon: (context) => const SettingCommonPage(),
        RouteSetting.userAgentSetting: (context) => const UserAgentSettingPage(),
        RouteSetting.darkMode: (context) => const DarkModePage(),
        RouteSetting.newFolderPage: (context) => const NewFolderPage(),
      },
      title: 'Flutter Demo',
      theme: provider.currentTheme,
      localizationsDelegates: const [
        S.delegate, // Add this line
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: Provider.of<GlobalProvider>(context).locale,
      supportedLocales: const [
        Locale('en', ''),
        Locale('zh', ''), // 中文
      ],
      // 暗黑主题
      themeMode: provider.currentTheme == ThemeData.light() ? ThemeMode.light : ThemeMode.dark,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

const String CHANNEL = "com.swan.shareData";

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late var provider = Provider.of<GlobalProvider>(context, listen: false);
  int progress = 0;
  bool topSearchShow = false;
  late String title = S.of(context).homeTitle;
  late String homeTitle = S.of(context).homeTitle;
  String searchString = "";
  DateTime? _lastPressedAt; //上次点击时间
  List<BrowserInfo> browsers = [];

  int get selectPosition => provider.selectPosition;
  late BrowserInfo initInfo;
  GlobalKey<WebViewPagerState> pagerStateKey = GlobalKey();
  GlobalKey<BottomToolState> bottomToolKey = GlobalKey();
  GlobalKey<SSLCookieState> sslCookieKey = GlobalKey();
  GlobalKey<BrowserPagerListState> browserPagerListState = GlobalKey();
  String initLoadUrl = homeUrl;
  bool isShowPagerAllList = false;
  bool isBlackAlphaShow = false;
  bool isShowSSLCookie = false;
  double initX = 0;
  double swipingX = 0;
  double widthInit = 60;
  bool isSwiping = false;
  String invokeMethod = "shareData";
  var channel = const MethodChannel(CHANNEL);

  void changeSearchShow(bool isShow) {
    setState(() {
      if (!isShow && (isShowPagerAllList || isShowSSLCookie)) {
        isBlackAlphaShow = true;
      } else {
        isBlackAlphaShow = isShow;
      }
      topSearchShow = isShow;
      changePagerAllHide();
      sslCookieAllHide();
    });
  }


  void blackAlphaShow() {
    setState(() {
      isBlackAlphaShow = true;
    });
  }

  void changePagerAllHide() {
    if (isShowPagerAllList && !topSearchShow) {
      setState(() {
        isBlackAlphaShow = false;
      });
    }
    browserPagerListState.currentState!.animationOut();
  }

  void sslCookieAllHide() {
    if (isShowSSLCookie && !topSearchShow) {
      setState(() {
        isBlackAlphaShow = false;
      });
    }
    sslCookieKey.currentState!.animationOut();
  }

  String checkUrlType(String url) {
    if (url.startsWith("file:///")) {
      return url;
    } else if (url.startsWith("content://")) {
      return url;
    } else {
      return provider.selectEngin.enginUrl + url;
    }
  }

  BrowserState? getPageNowState() => provider.getPageNowState();

  InAppWebViewController? getNowControl() => provider.getNowControl();

  BrowserInfo copyInit(String initUrl, [bool? isChange]) {
    var key = GlobalKey<BrowserState>();
    provider.browserKey.add(key);
    var info = BrowserInfo(
      onNewWindow: initInfo.onNewWindow,
      onSearchGo: initInfo.onSearchGo,
      loadUrl: initUrl,
      onTitleChange: initInfo.onTitleChange,
      onSearchChange: initInfo.onSearchChange,
      onProgress: initInfo.onProgress,
    );
    browsers.add(info);
    setState(() {
      if (isChange ?? false) {
        provider.setSelectPositionPage(browsers.length - 1);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          pagerStateKey.currentState?.changePage();
        });
      }
    });
    return info;
  }

  void changeTitle(String title) {
    setState(() {
      this.title = title;
    });
  }

  void removeNowPage(int index) {
    setState(() {
      provider.browserKey.removeAt(index);
      browsers.removeAt(index);
      if (selectPosition == index) {
        if (selectPosition == 0) {
          if (browsers.isNotEmpty) {
            provider.setSelectPositionPage(0);
            WidgetsBinding.instance.addPostFrameCallback((_) {
              pagerStateKey.currentState?.changePage();
              changePage();
            });
          } else {
            copyInit(homeUrl);
            provider.setSelectPositionPage(0);
            WidgetsBinding.instance.addPostFrameCallback((_) {
              pagerStateKey.currentState?.changePage();
              changePage();
            });
          }
        } else {
          provider.setSelectPositionPage(selectPosition - 1);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            pagerStateKey.currentState?.changePage();
            changePage();
          });
        }
      } else {
        if (index < selectPosition) {
          provider.setSelectPositionPage(selectPosition - 1);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            pagerStateKey.currentState?.changePage();
            changePage();
          });
        }
      }
    });
  }

  void changeBack() async {
    var control = getNowControl();
    if (control != null) {
      var back = await control.canGoBack();
      if (back) {
        control.goBack();
      } else {
        if (selectPosition != 0 || browsers.length > 1) {
          removeNowPage(selectPosition);
        } else {
          onBack();
        }
      }
    } else {
      onBack();
    }
  }

  @override
  void initState() {
    super.initState();
    //监听android端的传值
    channel.setMethodCallHandler((call) async {
      if (call.method == invokeMethod) {
        String callString = call.arguments;
        if (callString != "") {
          initLoadUrl = callString.isUrl() ? callString.completeUrl() : checkUrlType(callString);
          if (provider.browserKey.isNotEmpty) {
            copyInit(initLoadUrl, true);
          }
        }
      }
    });
    //获取每个page页的state
    var key = GlobalKey<BrowserState>();
    provider.browserKey.add(key);
    initInfo = BrowserInfo(
      onNewWindow: (url, isChange) {
        copyInit(url, isChange);
      },
      onSearchGo: (search) {
        setState(() {
          searchString = search ?? "";
        });
        getNowControl()?.loadUrl(
            urlRequest: URLRequest(
                url: WebUri(
                    searchString.isUrl() ? searchString.completeUrl() : provider.selectEngin.enginUrl + searchString)));
      },
      loadUrl: initLoadUrl,
      onTitleChange: (title) {
        changeTitle(title ?? homeTitle);
      },
      onSearchChange: (search) {
        setState(() {
          searchString = search ?? "";
        });
      },
      onProgress: (progress) {
        this.progress = progress;
      },
    );
    browsers.add(initInfo);
  }

  void onBack() {
    if (_lastPressedAt == null || DateTime.now().difference(_lastPressedAt!) > const Duration(seconds: 1)) {
      _lastPressedAt = DateTime.now();
    } else {
      SystemNavigator.pop();
    }
  }

  void hideSearch() {
    FocusScope.of(context).unfocus();
    changeSearchShow(false);
    getPageNowState()?.searchState.currentState?.animationRestart();
    // changePagerAllHide();
    // sslCookieAllHide();
  }

  List<BrowserPagerInfo> getPagerInfos() {
    List<BrowserPagerInfo> list = [];
    for (int index = 0; index < browsers.length; index++) {
      var title = provider.browserKey[index].currentState?.title;
      var nowUrl = provider.browserKey[index].currentState?.webUrl;
      var url = "";
      if (nowUrl != null) {
        if (nowUrl.isNotEmpty) {
          url = nowUrl;
        } else {
          url = browsers[index].loadUrl;
        }
      } else {
        url = browsers[index].loadUrl;
      }
      if (title != null) {
        if (title.isEmpty || title.startsWith(homeTitle)) {
          title = url.endsWith(homeUrl) ? homeTitle : url;
        }
      } else {
        title = url.endsWith(homeUrl) ? homeTitle : url;
      }
      list.add(BrowserPagerInfo(url: url, title: title));
    }
    return list;
  }

  void changePage() {
    var state = getPageNowState();
    setState(() {
      if (state != null) {
        title = state.title;
        searchString = state.url;
      }
    });
  }

  void openUrlForHistory([int position = 0, String searchString = ""]) async {
    dynamic type = await Navigator.of(context).pushNamed(RouteSetting.bookmarkHistorySavePage,
        arguments: SearchInfo(search: searchString, position: position));
    if (type != null && type is UrlOpenType) {
      copyInit(type.url.toString(), type.isNowOpen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).brightness == Brightness.light ? Colors.white : Colors.black,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  Stack(
                    children: [
                      WillPopScopeRoute(onBack: () async {
                        var control = getNowControl();
                        if (control != null) {
                          var back = await control.canGoBack();
                          if (back) {
                            if (isBlackAlphaShow) {
                              setState(() {
                                isBlackAlphaShow = false;
                              });
                            }
                            control.goBack();
                            return false;
                          } else {
                            if (selectPosition != 0 || browsers.length > 1) {
                              removeNowPage(selectPosition);
                              return false;
                            } else {
                              return true;
                            }
                          }
                        } else {
                          return true;
                        }
                      }),
                      !topSearchShow
                          ? TopTitleBar(
                              title: title,
                              homeTitle: homeTitle,
                              onScannerClick: () async {
                                changePagerAllHide();
                                String? url = await Navigator.push(
                                  context,
                                  MaterialPageRoute<String>(
                                    builder: (context) => const ScannerPage(),
                                  ),
                                );
                                if (url != null) {
                                  copyInit(url.toString(), true);
                                }
                              },
                              onTitleClick: () {
                                blackAlphaShow();
                                changeSearchShow(true);
                                getPageNowState()?.searchState.currentState?.animationStart();
                              },
                              onInfoClick: () {
                                changePagerAllHide();
                                if (isShowSSLCookie) {
                                  sslCookieAllHide();
                                } else {
                                  setState(() {
                                    isShowSSLCookie = true;
                                  });
                                  blackAlphaShow();
                                  sslCookieKey.currentState?.animationIn();
                                }
                              },
                              onRefreshClick: () {
                                sslCookieAllHide();
                                changePagerAllHide();
                                var control = getNowControl();
                                if (control != null) {
                                  control.reload();
                                }
                              },
                              onSearchIcon: () {
                                changePagerAllHide();
                              },
                            )
                          : TopSearchBar(
                              onSearch: (search) {
                                sslCookieAllHide();
                                changePagerAllHide();
                                searchString = search;
                                getNowControl()?.loadUrl(
                                    urlRequest: URLRequest(
                                        url: WebUri(searchString.isUrl()
                                            ? searchString.completeUrl()
                                            : provider.selectEngin.enginUrl + searchString)));
                                hideSearch();
                              },
                              searchKey: searchString,
                            ),
                    ],
                  ),
                  Expanded(
                      flex: 1,
                      child: Stack(
                        children: [
                          Visibility(
                            visible: browsers.isNotEmpty,
                            maintainState: true,
                            child: WebViewPager(
                              key: pagerStateKey,
                              browserPages: browsers,
                              select: selectPosition,
                              positionChange: () {
                                sslCookieAllHide();
                                changePage();
                              },
                              browserKeys: provider.browserKey,
                            ),
                          ),
                          if (Theme.of(context).brightness == Brightness.dark)
                            IgnorePointer(
                              child: GestureDetector(
                                onTap: () {
                                  hideSearch();
                                },
                                child: Container(
                                  color: const Color(0xFF3E3E3E).withOpacity(provider.maskAlpha / 100),
                                ),
                              ),
                            ),
                          if (isBlackAlphaShow)
                            GestureDetector(
                              onTap: () {
                                hideSearch();
                              },
                              child: Container(
                                color: ThemeColors.alphaColorDark,
                              ),
                            ),
                          // if (progress != 100)
                          Visibility(
                              visible: isShowSSLCookie,
                              maintainState: true,
                              child: FutureBuilder(
                                future: getNowControl()?.getCertificate(),
                                builder: (context, sp) {
                                  return SSLCookieView(
                                    key: sslCookieKey,
                                    url: getPageNowState()?.webUrl ?? "",
                                    title: title,
                                    sslInfo: sp.connectionState == ConnectionState.done
                                        ? SSLInfo(
                                            name: sp.data?.issuedTo?.CName ?? "-",
                                            end: sp.data?.validNotAfterDate?.formatTime(context) ?? "-",
                                            oName: sp.data?.issuedTo?.OName ?? "-",
                                            ouName: sp.data?.issuedTo?.UName ?? "-",
                                            start: sp.data?.validNotBeforeDate?.formatTime(context) ?? "-",
                                            tName: sp.data?.issuedBy?.CName ?? "-",
                                            tOName: sp.data?.issuedBy?.OName ?? "-",
                                          )
                                        : const SSLInfo(
                                            name: "-",
                                            end: "-",
                                            oName: "-",
                                            ouName: "-",
                                            start: "-",
                                            tName: "-",
                                            tOName: "-"),
                                    onAnimationOut: () {
                                      setState(() {
                                        isShowSSLCookie = false;
                                      });
                                    },
                                    cookies: CookieManager().getCookies(url: WebUri(getPageNowState()?.webUrl ?? "")),
                                    onClick: () {
                                      sslCookieAllHide();
                                    },
                                    onQRClick: () {},
                                    onHistoryClick: () {
                                      openUrlForHistory(1, title);
                                    },
                                  );
                                },
                              )),
                          Visibility(
                            visible: isShowPagerAllList,
                            maintainState: true, // 这里设置为 true，保留状态
                            child: BrowserPagerList(
                                onAnimationOut: () {
                                  setState(() {
                                    isShowPagerAllList = false;
                                  });
                                },
                                key: browserPagerListState,
                                select: selectPosition,
                                list: getPagerInfos(),
                                onDeletePager: (index) {
                                  removeNowPage(index);
                                },
                                onAddPager: () {
                                  bottomToolKey.currentState?.startPageButtonAnimation();
                                  copyInit(homeUrl);
                                  changePagerAllHide();
                                },
                                onSelect: (index) {
                                  setState(() {
                                    changePagerAllHide();
                                    provider.setSelectPositionPage(index);
                                    WidgetsBinding.instance.addPostFrameCallback((_) {
                                      pagerStateKey.currentState?.changePage();
                                    });
                                  });
                                }),
                          ),
                        ],
                      )),
                  BottomToolBar(
                    key: bottomToolKey,
                    pageSize: browsers.length,
                    onPageLongClick: () {
                      sslCookieAllHide();
                      changePagerAllHide();
                      copyInit(homeUrl, true);
                    },
                    onBackClick: () {
                      sslCookieAllHide();
                      changePagerAllHide();
                      changeBack();
                    },
                    onForwardClick: () async {
                      sslCookieAllHide();
                      changePagerAllHide();
                      var control = getNowControl();
                      if (control != null) {
                        var forward = await control.canGoForward();
                        if (forward) {
                          control.goForward();
                        }
                      }
                    },
                    onHomeClick: () {
                      sslCookieAllHide();
                      changePagerAllHide();
                      getNowControl()?.loadFile(assetFilePath: homeUrl);
                    },
                    onPageClick: () {
                      setState(() {
                        topSearchShow = false;
                      });
                      sslCookieAllHide();
                      if (isShowPagerAllList) {
                        changePagerAllHide();
                      } else {
                        setState(() {
                          isShowPagerAllList = true;
                        });
                        blackAlphaShow();
                        browserPagerListState.currentState!.animationIn();
                      }
                    },
                    onMenuClick: () {
                      sslCookieAllHide();
                      changePagerAllHide();
                      showDialog(
                          context: context,
                          builder: (mContext) {
                            return FuncBottomDialog(
                              onClick: (type) async {
                                var isShowChild = false;
                                switch (type) {
                                  case FuncBottomType.night:
                                    provider.toggleTheme();
                                    Hive.box(boolKey)
                                        .put(nightModeKey, !Hive.box(boolKey).get(nightModeKey, defaultValue: false));
                                    provider.setFuncBottomTypeOnChange(FuncBottomType.night);
                                    break;
                                  case FuncBottomType.bookmark:
                                    Navigator.of(context).pop();
                                    isShowChild = true;
                                    openUrlForHistory(0);
                                    break;
                                  case FuncBottomType.history:
                                    Navigator.of(context).pop();
                                    isShowChild = true;
                                    openUrlForHistory(1);
                                    break;
                                  case FuncBottomType.download:
                                    break;
                                  case FuncBottomType.hide:
                                    Hive.box(boolKey)
                                        .put(hideKey, !Hive.box(boolKey).get(hideKey, defaultValue: false));
                                    provider.setFuncBottomTypeOnChange(FuncBottomType.hide);
                                    // provider.updateLocale(() {
                                    //   Phoenix.rebirth(context);
                                    // });
                                    break;
                                  case FuncBottomType.share:
                                    Share.share(getPageNowState()?.webUrl ?? "");
                                    break;
                                  case FuncBottomType.addBookmark:
                                    String url = getPageNowState()?.webUrl ??  "";
                                    if(!url.endsWith(homeUrl) && url.isNotEmpty){
                                      Navigator.of(context).pop();
                                      isShowChild = true;
                                      showAddBookmarkDialog(context, BookmarkInfo(
                                          title: getPageNowState()?.title ?? "",
                                          url: url));
                                    }
                                    break;
                                  case FuncBottomType.desktop:
                                    var isOpen = !Hive.box(boolKey).get(desktopKey, defaultValue: false);
                                    provider.desktopChange(isOpen);
                                    Hive.box(boolKey).put(desktopKey, isOpen);
                                    provider.setFuncBottomTypeOnChange(FuncBottomType.desktop);
                                    break;
                                  case FuncBottomType.tool:
                                    break;
                                  case FuncBottomType.setting:
                                    Navigator.of(context).pop();
                                    isShowChild = true;
                                    Navigator.of(context).pushNamed(RouteSetting.settings, arguments: 2);
                                    break;
                                  case FuncBottomType.find:
                                    break;
                                  case FuncBottomType.save:
                                    break;
                                  case FuncBottomType.translate:
                                    break;
                                  case FuncBottomType.code:
                                    copyInit("view-source:${getPageNowState()?.webUrl}", true);
                                    break;
                                  case FuncBottomType.full:
                                    Hive.box(boolKey)
                                        .put(fullKey, !Hive.box(boolKey).get(fullKey, defaultValue: false));
                                    provider.setFuncBottomTypeOnChange(FuncBottomType.full);
                                    break;
                                  case FuncBottomType.imageMode:
                                    Navigator.of(context).pop();
                                    isShowChild = true;
                                    showImageModeDialog(context);
                                    break;
                                  case FuncBottomType.browserFlag:
                                    Navigator.of(context).pop();
                                    isShowChild = true;
                                    showUserAgentDialog(context);
                                    break;
                                  case FuncBottomType.refresh:
                                    getNowControl()?.reload();
                                    break;
                                  case FuncBottomType.network:
                                    break;
                                  case FuncBottomType.findRes:
                                    break;
                                  case FuncBottomType.noNetworkHtml:
                                    break;
                                  case FuncBottomType.scan:
                                    String? url = await Navigator.push(
                                      context,
                                      MaterialPageRoute<String>(
                                        builder: (context) => const ScannerPage(),
                                      ),
                                    );
                                    if (url != null) {
                                      copyInit(url.toString(), true);
                                    }
                                    break;
                                  case FuncBottomType.fontSize:
                                    break;
                                  case FuncBottomType.clear:
                                    break;
                                  case FuncBottomType.pdf:
                                    break;
                                }
                                if (!isShowChild) {
                                  Navigator.of(context).pop();
                                }
                              },
                            );
                          });
                    },
                  )
                ],
              ),
              GestureDetector(
                onHorizontalDragStart: (DragStartDetails details) {
                  isSwiping = true;
                  setState(() {
                    swipingX = 0;
                  });
                },
                onHorizontalDragUpdate: (DragUpdateDetails details) async {
                  if (!isSwiping) {
                    return;
                  }
                  var control = getNowControl();
                  if (control != null) {
                    bool isBack = await control.canGoBack();

                    if (isBack) {
                      if (swipingX >= 0 && swipingX + details.delta.dx >= 0) {
                        setState(() {
                          if (!isSwiping) {
                            return;
                          }
                          swipingX += details.delta.dx;
                        });
                      }
                    }
                    bool isForward = await control.canGoForward();
                    if (isForward) {
                      if (swipingX <= 0 && swipingX + details.delta.dx <= 0) {
                        setState(() {
                          if (!isSwiping) {
                            return;
                          }
                          swipingX += details.delta.dx;
                        });
                      }
                    }
                  }
                },
                onHorizontalDragEnd: (DragEndDetails details) {
                  isSwiping = false;
                  if (swipingX.abs() >= widthInit * 2) {
                    if (swipingX > 0) {
                      getNowControl()?.goBack();
                    } else if (swipingX < 0) {
                      getNowControl()?.goForward();
                    }
                  }
                  setState(() {
                    swipingX = 0;
                  });
                },
              ),
              GestureWidget(swipingX: swipingX / 2)
            ],
          ),
        ));
  }
}
