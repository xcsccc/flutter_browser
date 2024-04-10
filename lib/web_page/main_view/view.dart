import 'package:browser01/web_page/color/colors.dart';
import 'package:browser01/web_page/custom/custom.dart';
import 'package:browser01/web_page/custom/image_path.dart';
import 'package:browser01/web_page/now_icon.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

import '../../generated/l10n.dart';

class BrowserPagerInfo {
  final String url;
  final String title;

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
                                                        imageUrl:
                                                            "${item.url.extractDomainWithProtocol()!}/favicon.ico",
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
  final String? cookies;
  final SSLInfo? sslInfo;
  final Function onAnimationOut;

  const SSLCookieView(
      {super.key,
      required this.url,
      required this.title,
      this.cookies,
      this.sslInfo,
      required this.onAnimationOut});

  @override
  State<StatefulWidget> createState() => _SSLCookieState();
}

class _SSLCookieState extends State<SSLCookieView>
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
      begin: const Offset(0, 0),
      end: const Offset(0, 0.2),
    ).animate(_controller);
    _controller.addListener(animationOutFinish);
    super.initState();
  }

  void animationIn() {
    setState(() {
      isShow = true;
    });
    _controller.forward();
  }

  void animationOutFinish() {
    if (_controller.isCompleted && _animation.value.dy <= 0.0) {
      widget.onAnimationOut();
    }
  }

  void animationOut() {
    setState(() {
      isShow = false;
    });
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
        opacity: isShow ? 1 : 0,
        duration: const Duration(milliseconds: 200),
        child: SlideTransition(
            position: _animation,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.light
                          ? ThemeColors.alphaColorWhite
                          : ThemeColors.alphaColorBlack,
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20))),
                  child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Expanded(
                                  child: Column(
                                children: [
                                  // Marquee(
                                  //   text: widget.url,
                                  //   style: const TextStyle(fontSize: 13),
                                  //   scrollAxis: Axis.horizontal,
                                  // ),
                                  // Marquee(
                                  //   text: widget.title,
                                  //   style: const TextStyle(fontSize: 13),
                                  //   scrollAxis: Axis.horizontal,
                                  // )
                                ],
                              )),
                              IconImageButton(
                                res: AppImages.history,
                                onClick: () {},
                              ),
                              IconImageButton(
                                res: AppImages.code,
                                onClick: () {},
                              )
                            ],
                          ),
                          if (widget.cookies != null)
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: GestureDetector(
                                  onTap: () {},
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text("Cookies",
                                        style: TextStyle(
                                            color: ThemeColors
                                                .progressStartColor)),
                                  )),
                            ),
                          if (widget.sslInfo != null)
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: GestureDetector(
                                onTap: () {},
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(S.of(context).certificate,
                                      style: TextStyle(
                                          color:
                                              ThemeColors.progressStartColor)),
                                ),
                              ),
                            )
                        ],
                      )),
                ),
              ],
            )));
  }
}
