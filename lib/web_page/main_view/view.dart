import 'package:browser01/web_page/color/colors.dart';
import 'package:browser01/web_page/custom/custom.dart';
import 'package:browser01/web_page/custom/image_path.dart';
import 'package:browser01/web_page/dialog/cookie_dialog.dart';
import 'package:browser01/web_page/dialog/long_click_dialog.dart';
import 'package:browser01/web_page/dialog/ssl_dialog.dart';
import 'package:browser01/web_page/now_icon.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import '../../generated/l10n.dart';

class BrowserPagerInfo {
  final String url;
  final String title;

  @override
  String toString() {
    return 'BrowserPagerInfo{url: $url, title: $title}';
  }

  const BrowserPagerInfo({required this.url, required this.title});
}

class BrowserPagerList extends StatefulWidget {
  final List<BrowserPagerInfo> list;
  final ValueChanged<int> onDeletePager;
  final Function onAddPager;
  final ValueChanged<int> onSelect;
  final int select;
  final Function onAnimationOut;

  const BrowserPagerList({
    super.key,
    required this.list,
    required this.onDeletePager,
    required this.onAddPager,
    required this.onSelect,
    required this.select,
    required this.onAnimationOut,
  });

  @override
  State<StatefulWidget> createState() => BrowserPagerListState();
}

class BrowserPagerListState extends State<BrowserPagerList>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;
  bool isShow = true;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _animation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: const Offset(0, 0),
    ).animate(_controller);
    _controller.addListener(animationOutFinish);
    super.initState();
  }

  void animationIn() {
    setState(() {
      isShow = true;
    });
    _controller.reset();
    _animation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: const Offset(0, 0.0),
    ).animate(_controller);
    _controller.forward();
  }

  void animationOutFinish() {
    if (_controller.isCompleted && _animation.value.dy >= 0.2) {
      widget.onAnimationOut();
    }
  }

  void animationOut() {
    setState(() {
      isShow = false;
    });
    _controller.reset();
    _animation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(0, 0.2),
    ).animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: isShow ? 1 : 0,
      duration: const Duration(milliseconds: 200),
      child: SlideTransition(
          position: _animation,
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Align(
                alignment: Alignment.bottomCenter,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.light
                          ? ThemeColors.alphaColorWhite
                          : ThemeColors.alphaColorBlack,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20))),
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemExtent: 50,
                      physics: const BouncingScrollPhysics(),
                      itemCount: widget.list.length + 1,
                      itemBuilder: (context, index) {
                        if (index == widget.list.length) {
                          return Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  widget.onAddPager();
                                },
                                borderRadius: BorderRadius.circular(0),
                                child: const SizedBox(
                                  height: 50,
                                  child: Center(
                                    child: IconImageButton(res: AppImages.add),
                                  ),
                                ),
                              ));
                        } else {
                          var item = widget.list[index];
                          return Material(
                              color: Colors.transparent,
                              child: Dismissible(
                                key: Key(DateTime.now()
                                    .millisecondsSinceEpoch
                                    .toString()),
                                child: InkWell(
                                  onTap: () {
                                    widget.onSelect(index);
                                  },
                                  borderRadius: BorderRadius.circular(10),
                                  child: SizedBox(
                                    height: 50,
                                    width: double.infinity,
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          height: 50,
                                          width: 50,
                                          child: Padding(
                                            padding: const EdgeInsets.all(15),
                                            child: DecoratedBox(
                                                decoration: const BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                5))),
                                                child: item.url
                                                            .extractDomainWithProtocol() ==
                                                        null
                                                    ? Image.asset(
                                                        AppImages.icon,
                                                        width: 20,
                                                        height: 20,
                                                        fit: BoxFit.cover)
                                                    : CachedNetworkImage(
                                                        imageUrl: item.url
                                                                .iconUrl() ??
                                                            "",
                                                        errorWidget: (context,
                                                            url, error) {
                                                          return Image.asset(
                                                              AppImages.icon,
                                                              width: 20,
                                                              height: 20,
                                                              fit:
                                                                  BoxFit.cover);
                                                        },
                                                      )),
                                          ),
                                        ),
                                        Expanded(
                                            child: Text(item.title,
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: widget.select ==
                                                            index
                                                        ? ThemeColors
                                                            .progressStartColor
                                                        : null),
                                                overflow:
                                                    TextOverflow.ellipsis)),
                                        IconImageButton(
                                          res: AppImages.close,
                                          onClick: () {
                                            widget.onDeletePager(index);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                onDismissed: (direction) {
                                  if (index == widget.list.length) {
                                    return;
                                  }
                                  widget.onDeletePager(index);
                                },
                              ));
                        }
                      }),
                )),
          )),
    );
  }
}

class SSLInfo {
  final String name;
  final String oName;
  final String ouName;
  final String tName;
  final String tOName;

  @override
  String toString() {
    return 'SSLInfo{name: $name, oName: $oName, ouName: $ouName, tName: $tName, tOName: $tOName, start: $start, end: $end}';
  }

  final String start;
  final String end;

  const SSLInfo(
      {required this.name,
      required this.end,
      required this.oName,
      required this.ouName,
      required this.start,
      required this.tName,
      required this.tOName});
}

class SSLCookieView extends StatefulWidget {
  final String url;
  final String title;
  final Future<List<Cookie>> cookies;
  final SSLInfo? sslInfo;
  final Function onAnimationOut;
  final Function onQRClick;
  final Function onClick;
  final Function onHistoryClick;

  const SSLCookieView(
      {super.key,
      required this.url,
      required this.title,
      required this.cookies,
      this.sslInfo,
      required this.onAnimationOut,
      required this.onQRClick,
      required this.onHistoryClick,
      required this.onClick});

  @override
  State<StatefulWidget> createState() => SSLCookieState();
}

class SSLCookieState extends State<SSLCookieView>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;
  bool isShow = true;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _animation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: const Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.addListener(animationOutFinish);
    super.initState();
  }

  void animationIn() {
    setState(() {
      isShow = true;
    });
    _controller.reset();
    _animation = Tween<Offset>(
      begin: const Offset(0, -0.2),
      end: const Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _controller.forward();
  }

  void animationOutFinish() {
    if (_animation.isCompleted && !isShow) {
      widget.onAnimationOut();
    }
  }

  void animationOut() {
    setState(() {
      isShow = false;
    });
    _controller.reset();
    _animation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(0, -0.2),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    var richStrList = widget.url.splitToRich();
    return AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return AnimatedOpacity(
              opacity: isShow ? 1 : 0,
              duration: const Duration(milliseconds: 200),
              child: SlideTransition(
                position: _animation,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? ThemeColors.alphaColorWhite
                                  : ThemeColors.alphaColorBlack,
                          borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20))),
                      child: Material(
                        color: Colors.transparent,
                        shadowColor: Colors.transparent,
                        surfaceTintColor: Colors.transparent,
                        child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                        child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.title,
                                          style: const TextStyle(fontSize: 16),
                                          textAlign: TextAlign.start,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 5),
                                        RichText(
                                          text: TextSpan(
                                              text: richStrList.first,
                                              style: TextStyle(
                                                  color: ThemeColors.fixColor,
                                                  fontSize: 15),
                                              children: [
                                                if (richStrList.length > 1)
                                                  TextSpan(
                                                      text: richStrList[1],
                                                      style: TextStyle(
                                                          color: ThemeColors
                                                              .indicatorLightGrayUnSelectColorBlack,
                                                          fontSize: 15)),
                                                if (richStrList.length > 2)
                                                  TextSpan(
                                                      text: richStrList[2],
                                                      style: TextStyle(
                                                          color: Theme.of(context)
                                                                      .brightness ==
                                                                  Brightness
                                                                      .light
                                                              ? Colors.black
                                                              : Colors.white,
                                                          fontSize: 15)),
                                                if (richStrList.length > 3)
                                                  TextSpan(
                                                      text: richStrList[3],
                                                      style: TextStyle(
                                                          color: ThemeColors
                                                              .indicatorLightGrayUnSelectColorBlack,
                                                          fontSize: 15))
                                              ]),
                                        ),
                                      ],
                                    )),
                                    IconImageButton(
                                      res: AppImages.history,
                                      onClick: () {
                                        widget.onHistoryClick();
                                      },
                                    ),
                                    IconImageButton(
                                      res: AppImages.qr,
                                      onClick: () {
                                        widget.onQRClick();
                                      },
                                    )
                                  ],
                                ),
                                FutureBuilder(
                                    future: widget.cookies,
                                    builder: (context, sp) {
                                      if (sp.connectionState ==
                                              ConnectionState.done &&
                                          sp.data != null &&
                                          sp.data!.isNotEmpty) {
                                        return GestureDetector(
                                          onTap: () {
                                            widget.onClick();
                                            showCookiesDialog(sp.data ?? [],
                                                widget.url, context);
                                          },
                                          child: Container(
                                              width: double.infinity,
                                              height: 50,
                                              color: Colors.transparent,
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text("Cookies",
                                                    style: TextStyle(
                                                        color: ThemeColors
                                                            .progressStartColor)),
                                              )),
                                        );
                                      } else {
                                        return Container();
                                      }
                                    }),
                                if (widget.sslInfo != null)
                                  GestureDetector(
                                    onTap: () {
                                      widget.onClick();
                                      showSSLDialog(widget.sslInfo!, context);
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      height: 50,
                                      color: Colors.transparent,
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(S.of(context).certificate,
                                            style: TextStyle(
                                                color: ThemeColors
                                                    .progressStartColor)),
                                      ),
                                    ),
                                  )
                              ],
                            )),
                      ),
                    )
                  ],
                ),
              ));
        });
  }
}

class GestureWidget extends StatefulWidget {
  final double swipingX;

  const GestureWidget({super.key, required this.swipingX});

  @override
  State<StatefulWidget> createState() => GestureState();
}

class GestureState extends State<GestureWidget> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        Transform.translate(
            offset: Offset(
                -60 + (widget.swipingX > 0
                    ? widget.swipingX >= 60
                        ? 60
                        : widget.swipingX
                    : 0),
                screenHeight / 2 - 30),
            child: backOrForward(true),),
        Transform.translate(
            offset: Offset(
                screenWidth + (widget.swipingX < 0
                    ? widget.swipingX <= -60
                        ? -60
                        : widget.swipingX
                    : 0),
                screenHeight / 2 - 30),
            child:  backOrForward(false)),
      ],
    );
  }

  Widget backOrForward(bool isBack) {
    return SizedBox(
        height: 60,
        width: 60,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: isBack
                ? const BorderRadius.only(
                    topRight: Radius.circular(15),
                    bottomRight: Radius.circular(15))
                : const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    bottomLeft: Radius.circular(15)),
            color:  ThemeColors.alphaColorGray,
          ),
          child: Transform.rotate(
            angle: isBack ? 0 : 3,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Image.asset(AppImages.back,
                  color: ThemeColors.iconColorLight),
            ),
          ),
        ));
  }
}
