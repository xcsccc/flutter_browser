import 'package:browser01/web_page/custom/image_path.dart';
import 'package:browser01/web_page/now_icon.dart';
import 'package:flutter/cupertino.dart';

class BottomToolBar extends StatefulWidget {
  final Function onBackClick;
  final Function onForwardClick;
  final Function onHomeClick;
  final Function onPageClick;
  final Function onPageLongClick;
  final Function onMenuClick;
  final int pageSize;

  const BottomToolBar(
      {super.key,
      required this.onBackClick,
      required this.onForwardClick,
      required this.onHomeClick,
      required this.onPageClick,
      required this.onPageLongClick,
      required this.onMenuClick,
      required this.pageSize});

  @override
  State<StatefulWidget> createState() => BottomToolState();
}

class BottomToolState extends State<BottomToolBar> with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation<Offset> animation;

  @override
  void initState() {
    controller = AnimationController(vsync: this,duration: const Duration(milliseconds: 100));
    animation = Tween<Offset>(begin: const Offset(0,0),end: const Offset(0,-0.5)).animate(controller);
    controller.addListener(animationOver);
    super.initState();
  }

  void startPageButtonAnimation(){
    setState(() {
      controller.forward();
    });
  }

  void animationOver(){
    if(controller.isCompleted){
      controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 50,
        child: Row(
          children: [
            Expanded(
                child: IconImageButton(
              res: AppImages.back,
              onClick: () {
                widget.onBackClick();
              },
              width: double.infinity,
              radius: 10,
            )),
            Expanded(
                child: IconImageButton(
                    res: AppImages.back,
                    rotation: 1,
                    onClick: () {
                      widget.onForwardClick();
                    },
                    width: double.infinity,
                    radius: 10)),
            Expanded(
                child: IconImageButton(
                    res: AppImages.home,
                    onClick: () {
                      widget.onHomeClick();
                    },
                    width: double.infinity,
                    radius: 10)),
            Expanded(
                child:  SlideTransition(position: animation,child: Stack(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(17),
                    child: Text(
                      "${widget.pageSize}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 10),
                    ),
                  ),
                ),
              IconImageButton(
                    res: AppImages.pageBg,
                    onClick: () {
                      widget.onPageClick();
                    },
                    width: double.infinity,
                    onLongClick: () {
                      startPageButtonAnimation();
                      widget.onPageLongClick();
                    },
                    radius: 10)
              ],
            ))),
            Expanded(
                child: IconImageButton(
                    res: AppImages.settingMenu,
                    onClick: () {
                      widget.onMenuClick();
                    },
                    width: double.infinity,
                    radius: 10)),
          ],
        ));
  }
}
