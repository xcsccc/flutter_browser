import 'package:browser01/web_page/custom/image_path.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../now_icon.dart';

class TopTitleBar extends StatefulWidget {
  final String title;
  final String homeTitle;
  final Function onScannerClick;
  final Function onTitleClick;
  final Function onInfoClick;
  final Function onRefreshClick;
  final Function onSearchIcon;

  const TopTitleBar(
      {super.key,
      required this.title,
      required this.homeTitle,
      required this.onScannerClick,
      required this.onTitleClick,
      required this.onInfoClick, required this.onRefreshClick, required this.onSearchIcon});

  @override
  State<StatefulWidget> createState() => TopTitleState();
}

class TopTitleState extends State<TopTitleBar> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Row(children: [
        IconImageButton(
          res: widget.homeTitle == widget.title
              ? AppImages.search
              : AppImages.urlInfo,
          onClick: () {
            if (widget.homeTitle != widget.title) {
              widget.onInfoClick();
            }else{
              widget.onSearchIcon();
            }
          },
        ),
        Expanded(
            flex: 1,
            child: GestureDetector(
                onTap: () {
                  widget.onTitleClick();
                },
                child: SizedBox(
                    height: 50,
                    child: Container(
                        color: Colors.transparent,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          widget.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 15),
                        ))))),
        IconImageButton(
          res: widget.homeTitle == widget.title
              ? AppImages.scanner:AppImages.refresh,
          onClick: () {
            if( widget.homeTitle == widget.title){
              widget.onScannerClick();
            }else{
              widget.onRefreshClick();
            }
          },
        )
      ]),
    );
  }
}
