import 'dart:io';

import 'package:browser01/web_page/color/colors.dart';
import 'package:browser01/web_page/custom/image_path.dart';
import 'package:browser01/web_page/model/history_info.dart';
import 'package:browser01/web_page/now_icon.dart';
import 'package:browser01/web_page/provider/main_provider.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../generated/l10n.dart';
import 'custom/custom.dart';
import 'dialog/long_click_dialog.dart';
import 'main_view/progress_bar.dart';

class BrowserInfo {
  final String loadUrl;
  final ValueChanged<String?> onTitleChange;
  final ValueChanged<String?> onSearchChange;
  final ValueChanged<String?> onSearchGo;
  final ValueChanged<int> onProgress;
  final Function(String, bool) onNewWindow;

  const BrowserInfo({
    required this.onSearchGo,
    required this.loadUrl,
    required this.onTitleChange,
    required this.onSearchChange,
    required this.onProgress,
    required this.onNewWindow,
  });
}

class BrowserView extends StatefulWidget {
  final BrowserInfo browserInfo;

  const BrowserView({super.key, required this.browserInfo});

  @override
  State<StatefulWidget> createState() => BrowserState();
}

class BrowserState extends State<BrowserView>
    with AutomaticKeepAliveClientMixin {
  late var provider = Provider.of<GlobalProvider>(context);
  String home = homeUrl;
  bool isHomeUrl = false;
  String nowSearchString = "";
  InAppWebViewController? control;
  FindInteractionController findController = FindInteractionController();
  String url = "";
  String webUrl = "";
  String title = "";
  bool _isSelect = true;
  LongPressDownDetails? details = null;
  List<String> imgUrls = [];
  bool isWebShow = true;
  int progress = 0;
  GlobalKey<SearchAllState> searchState = GlobalKey();

  set isSelect(bool value) {
    if (_isSelect != value) {
      setState(() {
        _isSelect = value;
      });
    }
  }

  Future<String> loadCss() async {
    var androidInfo = await DeviceInfoPlugin().androidInfo;
    if (androidInfo.version.sdkInt >= 33) {
      return await rootBundle.loadString('assets/css/night.css');
    } else {
      return await rootBundle.loadString('assets/css/night10.css');
    }
  }

  InAppWebViewSettings getSetting() {
    return provider.settings;
  }

  void checkHomeUrl() async {
    var url = await control!.getUrl() ?? "";
    setState(() {
      isHomeUrl = url.toString().startsWith('file:///');
    });
  }

  void loadDark() async {
    if (Platform.isAndroid &&
        provider.currentTheme == ThemeData.dark() &&
        !url.toString().endsWith(homeUrl)) {
      control?.evaluateJavascript(source: """
              (function() {
                var parent = document.getElementsByTagName('head').item(0);
                var style = document.createElement('style');
                style.type = 'text/css';
                style.innerHTML = window.atob('${control?.injectCSSCode(source: await loadCss())}');
                parent.appendChild(style);
              })();
            """);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(
      children: [
        GestureDetector(onLongPressDown: (details) {
          this.details = details;
        }, child: Consumer<GlobalProvider>(builder: (context, notifier, child) {
          return Visibility(
              visible: isWebShow,
              maintainState: true,
              child: InAppWebView(
                  keepAlive: InAppWebViewKeepAlive(),
                  initialUrlRequest: widget.browserInfo.loadUrl
                              .endsWith(homeUrl) ||
                          (!widget.browserInfo.loadUrl.isUrl() &&
                              !widget.browserInfo.loadUrl.isBase64() &&
                              !widget.browserInfo.loadUrl
                                  .startsWith("view-source:"))
                      ? null
                      : URLRequest(
                          url: WebUri(widget.browserInfo.loadUrl.isBase64()
                              ? widget.browserInfo.loadUrl
                              : widget.browserInfo.loadUrl
                                      .startsWith("view-source:")
                                  ? widget.browserInfo.loadUrl
                                  : widget.browserInfo.loadUrl.completeUrl())),
                  initialData: !widget.browserInfo.loadUrl.endsWith(homeUrl) &&
                          !widget.browserInfo.loadUrl.isUrl() &&
                          !widget.browserInfo.loadUrl.isBase64() &&
                          !widget.browserInfo.loadUrl.startsWith("view-source:")
                      ? InAppWebViewInitialData(
                          data: widget.browserInfo.loadUrl)
                      : null,
                  initialFile: widget.browserInfo.loadUrl.endsWith(homeUrl)
                      ? widget.browserInfo.loadUrl
                      : null,
                  findInteractionController: findController,
                  initialSettings: getSetting(),
                  onDownloadStartRequest: (control, request) {
                    print("onDownloadStartRequest");
                  },
                  onTitleChanged: (control, title) {
                    if (webUrl.toString().endsWith(homeUrl)) {
                      this.title = S.of(context).homeTitle;
                    } else {
                      this.title = title ?? "";
                    }
                    print("change control:$title");

                    if (webUrl.toString().startsWith("https://") ||
                        webUrl.toString().startsWith("http://")) {
                      var time = DateTime.now().millisecondsSinceEpoch;
                      var list = HistoryInfo.getAll().where((element) =>
                          element.time.formatTime(context) ==
                              time.formatTime(context) &&
                          element.url == webUrl &&
                          element.title == title);
                      if (list.isNotEmpty) {
                        for (var element in list) {
                          provider.historyDelete(element);
                        }
                      }
                      HistoryInfo(
                              title: this.title,
                              url: webUrl.toString(),
                              time: time)
                          .save();
                    }

                    if (_isSelect) {
                      widget.browserInfo.onTitleChange(title);
                    }
                  },
                  onLongPressHitTestResult: (control, hit) async {
                    var info = await control.requestFocusNodeHref();
                    if (info != null) {
                      if (info.url != null || info.src != null) {
                        // ignore: use_build_context_synchronously
                        showCustomMenu(
                            context,
                            details?.globalPosition.dx ?? 0,
                            details?.globalPosition.dy ?? 0,
                            widget.browserInfo,
                            info,
                            title,
                            webUrl,
                            imgUrls);
                      }
                    }
                  },
                  //长按text中的菜单
                  contextMenu: ContextMenu(menuItems: [
                    ContextMenuItem(title: "title 1", id: 1),
                    ContextMenuItem(title: "title 2", id: 2),
                    ContextMenuItem(title: "title 3", id: 3),
                    ContextMenuItem(title: "title 4", id: 4),
                  ]),
                  onWebViewCreated: (control) {
                    this.control = control;
                  },
                  onProgressChanged: (control, progress) {
                    // widget.browserInfo.onProgress(progress);
                    setState(() {
                      this.progress = progress;
                    });
                    if (progress == 100) {
                      setState(() {
                        isWebShow = true;
                      });
                    }
                  },
                  onCloseWindow: (control) {},
                  onCreateWindow: (control, window) async {
                    widget.browserInfo
                        .onNewWindow(window.request.url.toString(), true);
                    return true;
                  },
                  onLoadResource: (control, res) {
                    if (res.initiatorType == "img" &&
                        !imgUrls.contains(res.url.toString())) {
                      imgUrls.add(res.url.toString());
                    }
                  },
                  onLoadStart: (control, url) async {
                    setState(() {
                      isWebShow = false;
                    });
                    loadDark();
                    imgUrls.clear();
                    webUrl = url.toString();
                    checkHomeUrl();
                    this.url = url.toString().startsWith('file:///')
                        ? ""
                        : url.toString().extractSearchKeyword();
                    widget.browserInfo.onSearchChange(this.url);
                  },
                  onLoadStop: (control, url) async {
                    loadDark();
                    setState(() {
                      isWebShow = true;
                      progress = 100;
                    });
                  },
                  gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                    Factory<VerticalDragGestureRecognizer>(
                      () => VerticalDragGestureRecognizer(),
                    ),
                    Factory<HorizontalDragGestureRecognizer>(
                      () => HorizontalDragGestureRecognizer(),
                    ),
                    Factory<OneSequenceGestureRecognizer>(
                          () => EagerGestureRecognizer(),
                    ),
                  }));
        })),
        ProgressBarAnimate(end: progress.toDouble()),
        if (isHomeUrl)
          SearchAllWidget(
            key: searchState,
            onSearch: (search) {
              nowSearchString = search;
              widget.browserInfo.onSearchGo(search);
            },
            searchStr: nowSearchString,
          )
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class SearchAllWidget extends StatefulWidget {
  final ValueChanged<String> onSearch;
  final String searchStr;

  const SearchAllWidget(
      {super.key, required this.onSearch, required this.searchStr});

  @override
  State<StatefulWidget> createState() => SearchAllState();
}

class SearchAllState extends State<SearchAllWidget>
    with SingleTickerProviderStateMixin {
  TextEditingController controller = TextEditingController();
  FocusNode node = FocusNode();
  String searchString = "";
  bool searchIconIsShow = false;
  late AnimationController animationController;
  late Animation<Offset> animation;
  bool isAnimationTop = false;

  void _onFocusChange() {
    setState(() {
      searchIconIsShow = node.hasFocus;
      if (searchIconIsShow) {
        controller.selection = TextSelection(
          baseOffset: 0,
          extentOffset: controller.text.length,
        );
        animationStart();
      } else {
        animationRestart();
      }
    });
  }

  void animationStart() {
    if (isAnimationTop) {
      return;
    }
    isAnimationTop = true;
    setState(() {
      animationController.forward();
    });
  }

  void animationRestart() {
    if (!isAnimationTop) {
      return;
    }
    isAnimationTop = false;
    setState(() {
      animationController.reverse();
    });
  }

  @override
  void initState() {
    node.addListener(_onFocusChange);
    controller.text = widget.searchStr;
    searchString = widget.searchStr;
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    animation =
        Tween<Offset>(begin: const Offset(0, 0), end: const Offset(0, -0.5))
            .animate(animationController);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    node.removeListener(_onFocusChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Container(
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.white
                  : Colors.black,
            ),
          ),
          onTap: () {
            node.unfocus();
          },
        ),
        Align(
          alignment: const Alignment(0, -0.6),
          child: SlideTransition(
              position: animation,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 80,
                    width: 80,
                    child: DecoratedBox(
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.transparent,
                              width: 0,
                            ),
                            image: const DecorationImage(
                                image: AssetImage(AppImages.logo),
                                fit: BoxFit.fill),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20)))),
                  ),
                  Container(height: 10),
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Stack(
                          children: [
                            SizedBox(
                              height: 50,
                              width: double.infinity,
                              child: DecoratedBox(
                                  decoration: BoxDecoration(
                                      color:
                                          ThemeColors.borderColor.withAlpha(0),
                                      border: Border.all(
                                          color: ThemeColors.borderColor,
                                          width: 2.0),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(20)))),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: SizedBox(
                                          height: 50,
                                          child: TextField(
                                            focusNode: node,
                                            controller: controller,
                                            decoration: const InputDecoration(
                                              border: InputBorder.none,
                                              fillColor: Colors.transparent,
                                              hintStyle:
                                                  TextStyle(fontSize: 15),
                                            ),
                                            maxLines: 1,
                                            onChanged: (value) {
                                              setState(() {
                                                searchString = value;
                                              });
                                            },
                                            style:
                                                const TextStyle(fontSize: 15),
                                          ))),
                                  if (searchIconIsShow)
                                    IconImageButton(
                                      res: AppImages.search,
                                      onClick: () {
                                        if (searchString.isNotEmpty) {
                                          widget.onSearch(searchString);
                                        }
                                      },
                                    )
                                ],
                              ),
                            )
                          ],
                        )),
                  )
                ],
              )),
        ),
      ],
    );
  }
}

class WebViewPager extends StatefulWidget {
  final List<BrowserInfo> browserPages;
  final List<GlobalKey<BrowserState>> browserKeys;
  final int select;
  final Function positionChange;

  const WebViewPager(
      {super.key,
      required this.browserPages,
      required this.select,
      required this.positionChange,
      required this.browserKeys});

  @override
  State<StatefulWidget> createState() => WebViewPagerState();
}

class WebViewPagerState extends State<WebViewPager> {
  PageController controller = PageController(initialPage: 0);

  void changePage() {
    controller.jumpToPage(widget.select);
    change();
  }

  void change() {
    widget.positionChange();
    for (int i = 0; i < widget.browserKeys.length; i++) {
      widget.browserKeys[i].currentState?.isSelect = i == widget.select;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Theme.of(context).canvasColor,
        child: PageView.builder(
            itemCount: widget.browserKeys.length,
            physics: const NeverScrollableScrollPhysics(),
            controller: controller,
            onPageChanged: (_) {
              change();
            },
            itemBuilder: (context, index) {
              return Visibility(
                  maintainState: true,
                  child: BrowserView(
                      key: widget.browserKeys[index],
                      browserInfo: widget.browserPages[index]));
            }));
  }
}
