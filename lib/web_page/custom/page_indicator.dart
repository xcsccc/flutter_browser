import 'package:browser01/web_page/color/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PageIndicator extends StatefulWidget {
  final bool select;
  const PageIndicator({super.key, required this.select});

  @override
  State<StatefulWidget> createState() => PageIndicatorState();
}

class PageIndicatorState extends State<PageIndicator> {

  Color getNowColor(){
    Color now;
    if(Theme.of(context).brightness == Brightness.light){
      if(widget.select){
        now = ThemeColors.indicatorLightGraySelectColorBlack;
      }else{
        now =  ThemeColors.indicatorLightGrayUnSelectColorBlack;
      }
    }else{
      if(widget.select){
        now = ThemeColors.indicatorLightGrayUnSelectColorBlack;
      }else{
        now =  ThemeColors.indicatorLightGraySelectColorBlack;
      }
    }
    return now;
  }
  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.all(3),child: SizedBox(
      height: 14,
      width: 14,
      child: Container(
        decoration:  BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          color: getNowColor()
        ),
      ),
    ),);
  }
}
