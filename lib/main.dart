import 'dart:ffi';

import 'package:browser01/web_page/back/back_click.dart';
import 'package:browser01/web_page/bar/bottom_tool_bar.dart';
import 'package:browser01/web_page/color/colors.dart';
import 'package:browser01/web_page/custom/FuncBottomInfo.g.dart';
import 'package:browser01/web_page/custom/custom.dart';
import 'package:browser01/web_page/bar/top_search_bar.dart';
import 'package:browser01/web_page/bar/top_title_bar.dart';
import 'package:browser01/web_page/custom/func_bottom_info.dart';
import 'package:browser01/web_page/dialog/func_dialog.dart';
import 'package:browser01/web_page/dialog/user_agent_dialog.dart';
import 'package:browser01/web_page/main_view/progress_bar.dart';
import 'package:browser01/web_page/main_view/view.dart';
import 'package:browser01/web_page/page/scanner_page.dart';
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

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(FuncBottomInfoAdapter());
  await Hive.openBox<FuncBottomInfo>(funcBottomKey);
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
  State<StatefulWidget> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  late var provider = Provider.of<GlobalProvider>(context);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: RouteSetting.mainPage,
      routes: {
        RouteSetting.mainPage: (context) => const MyHomePage(),
        RouteSetting.scannerPage: (context) => const ScannerPage(),
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
      themeMode: provider.currentTheme == ThemeData.light()
          ? ThemeMode.light
          : ThemeMode.dark,
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
  int selectPosition = 0;
  late BrowserInfo initInfo;
  GlobalKey<WebViewPagerState> pagerStateKey = GlobalKey();
  GlobalKey<BottomToolState> bottomToolKey = GlobalKey();
  GlobalKey<BrowserPagerListState> browserPagerListState = GlobalKey();
  String initLoadUrl = homeUrl;
  bool isShowPagerAllList = false;
  bool isBlackAlphaShow = false;
  bool isShowSSLCookie = false;

  String invokeMethod = "shareData";
  var channel = const MethodChannel(CHANNEL);

  void changeSearchShow(bool isShow) {
    setState(() {
      if (!isShow && isShowPagerAllList) {
        isBlackAlphaShow = true;
      } else {
        isBlackAlphaShow = isShow;
      }
      topSearchShow = isShow;
      changePagerAllHide();
    });
  }

  @override
  void dispose() {
    super.dispose();
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

  String checkUrlType(String url) {
    if (url.startsWith("file:///")) {
      return url;
    } else if (url.startsWith("content://")) {
      return url;
    } else {
      return provider.selectEngin.enginUrl + url;
    }
  }

  BrowserState? getPageNowState() =>
      provider.browserKey[selectPosition].currentState;

  InAppWebViewController? getNowControl() => getPageNowState()?.control;

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
        selectPosition = browsers.length - 1;
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
            selectPosition = 0;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              pagerStateKey.currentState?.changePage();
              changePage();
            });
          } else {
            copyInit(homeUrl);
            selectPosition = 0;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              pagerStateKey.currentState?.changePage();
              changePage();
            });
          }
        } else {
          selectPosition -= 1;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            pagerStateKey.currentState?.changePage();
            changePage();
          });
        }
      } else {
        if (index < selectPosition) {
          selectPosition -= 1;
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
    debugPrint("selectLocale:${provider.selectLocale}");
    //监听android端的传值
    channel.setMethodCallHandler((call) async {
      if (call.method == invokeMethod) {
        String callString = call.arguments;
        if (callString != "") {
          initLoadUrl = callString.isUrl()
              ? callString.completeUrl()
              : checkUrlType(callString);
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
                url: WebUri(searchString.isUrl()
                    ? searchString.completeUrl()
                    : provider.selectEngin.enginUrl + searchString)));
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
    if (_lastPressedAt == null ||
        DateTime.now().difference(_lastPressedAt!) >
            const Duration(seconds: 1)) {
      _lastPressedAt = DateTime.now();
    } else {
      SystemNavigator.pop();
    }
  }

  void hideSearch() {
    FocusScope.of(context).unfocus();
    changeSearchShow(false);
    getPageNowState()?.searchState.currentState?.animationRestart();
    changePagerAllHide();
  }

  SSLInfo? getSSLInfo() {
    var control = getNowControl();
    var sslInfo = control?.getCertificate();
    if (sslInfo != null) {
      sslInfo.then((sslInfo) {
        if (sslInfo != null) {
          return SSLInfo(
            name: sslInfo.issuedBy?.CName ?? "-",
            end: sslInfo.validNotAfterDate?.timeZoneName ?? "-",
            oName: sslInfo.issuedBy?.OName ?? "-",
            ouName: sslInfo.issuedBy?.UName ?? "-",
            start: sslInfo.validNotBeforeDate?.timeZoneName ?? "-",
            tName: sslInfo.issuedTo?.CName ?? "-",
            tOName: sslInfo.issuedTo?.OName ?? "-",
          );
        }
      });
    }else{
      return null;
    }
  }

  List<BrowserPagerInfo> getPagerInfos() {
    List<BrowserPagerInfo> list = [];
    for (int index = 0; index < browsers.length; index++) {
      var title = provider.browserKey[index].currentState?.title;
      var url = provider.browserKey[index].currentState?.webUrl;
      if (title != null) {
        if (title.isEmpty) {
          title = url?.endsWith(homeUrl) ?? true ? homeTitle : url;
        }
      } else {
        title = url?.endsWith(homeUrl) ?? true ? homeTitle : url;
      }
      list.add(BrowserPagerInfo(url: url ?? "", title: title ?? homeTitle));
    }
    return list;
  }

  void changePage() {
    var state = getPageNowState();
    setState(() {
      if (state != null) {
        debugPrint("positionChange,url:${state.url}");
        debugPrint("positionChange,title:${state.title}");
        title = state.title;
        searchString = state.url;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).brightness == Brightness.light
            ? Colors.white
            : Colors.black,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
            child: Column(
          children: [
            Stack(
              children: [
                WillPopScopeRoute(onBack: () async {
                  var control = getNowControl();
                  if (control != null) {
                    var back = await control.canGoBack();
                    if (back) {
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
                          getPageNowState()
                              ?.searchState
                              .currentState
                              ?.animationStart();
                        },
                        onInfoClick: () {
                          setState(() {
                            isShowSSLCookie = true;
                          });
                          changePagerAllHide();
                        },
                        onRefreshClick: () {
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
                          changePagerAllHide();
                          searchString = search;
                          getNowControl()?.loadUrl(
                              urlRequest: URLRequest(
                                  url: WebUri(searchString.isUrl()
                                      ? searchString.completeUrl()
                                      : provider.selectEngin.enginUrl +
                                          searchString)));
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
                          changePage();
                        },
                        browserKeys: provider.browserKey,
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
                      ProgressBarAnimate(end: progress.toDouble()),
                    if (isShowSSLCookie)
                      SSLCookieView(
                        url: getPageNowState()!.webUrl,
                        title: title,
                        sslInfo: getSSLInfo(), onAnimationOut: (){
                        setState(() {
                          isShowSSLCookie = false;
                        });
                      },
                      ),
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
                            bottomToolKey.currentState
                                ?.startPageButtonAnimation();
                            copyInit(homeUrl);
                            changePagerAllHide();
                          },
                          onSelect: (index) {
                            setState(() {
                              changePagerAllHide();
                              selectPosition = index;
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
                changePagerAllHide();
                copyInit(homeUrl, true);
              },
              onBackClick: () {
                changePagerAllHide();
                changeBack();
              },
              onForwardClick: () async {
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
                changePagerAllHide();
                getNowControl()?.loadFile(assetFilePath: homeUrl);
              },
              onPageClick: () {
                setState(() {
                  topSearchShow = false;
                });
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
                              Hive.box(boolKey).put(
                                  nightModeKey,
                                  !Hive.box(boolKey)
                                      .get(nightModeKey, defaultValue: false));
                              provider.setFuncBottomTypeOnChange(
                                  FuncBottomType.night);
                              break;
                            case FuncBottomType.bookmark:
                              break;
                            case FuncBottomType.history:
                              break;
                            case FuncBottomType.download:
                              break;
                            case FuncBottomType.hide:
                              Hive.box(boolKey).put(
                                  hideKey,
                                  !Hive.box(boolKey)
                                      .get(hideKey, defaultValue: false));
                              provider.setFuncBottomTypeOnChange(
                                  FuncBottomType.hide);
                              // provider.updateLocale(() {
                              //   Phoenix.rebirth(context);
                              // });
                              break;
                            case FuncBottomType.share:
                              Share.share(getPageNowState()?.webUrl ?? "");
                              break;
                            case FuncBottomType.addBookmark:
                              break;
                            case FuncBottomType.desktop:
                              var isOpen = !Hive.box(boolKey)
                                  .get(desktopKey, defaultValue: false);
                              provider.desktopChange(isOpen);
                              Hive.box(boolKey).put(desktopKey, isOpen);
                              provider.setFuncBottomTypeOnChange(
                                  FuncBottomType.desktop);
                              break;
                            case FuncBottomType.tool:
                              break;
                            case FuncBottomType.setting:
                              break;
                            case FuncBottomType.find:
                              break;
                            case FuncBottomType.save:
                              break;
                            case FuncBottomType.translate:
                              break;
                            case FuncBottomType.code:
                              copyInit(
                                  "view-source:${getPageNowState()?.webUrl}",
                                  true);
                              break;
                            case FuncBottomType.full:
                              Hive.box(boolKey).put(
                                  fullKey,
                                  !Hive.box(boolKey)
                                      .get(fullKey, defaultValue: false));
                              provider.setFuncBottomTypeOnChange(
                                  FuncBottomType.full);
                              break;
                            case FuncBottomType.imageMode:
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
        )));
  }
}
