import 'dart:math';

import 'package:browser01/web_page/model/tree_node.dart';
import 'package:browser01/web_page/provider/main_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../generated/l10n.dart';
import '../custom/image_path.dart';
import '../dialog/add_bookmark.dart';
import '../model/bookmark_info.dart';
import '../model/file_type.dart';
import '../now_icon.dart';

class NewFolderPage extends StatefulWidget {
  const NewFolderPage({super.key});

  @override
  State<StatefulWidget> createState() => _NewFolderState();
}

class _NewFolderState extends State<NewFolderPage>
    with SingleTickerProviderStateMixin {
  TextEditingController controller = TextEditingController();
  String newName = "";
  late GlobalProvider provider = Provider.of<GlobalProvider>(context);
  late TreeNode selectNode = provider.treeNodeInfo;
  late AnimationController controllerAnimation;
  late Animation<double> animation;
  late Animation<double> alphaAnimation;

  @override
  void initState() {
    controllerAnimation = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    animation = Tween<double>(end: pi, begin: 0).animate(controllerAnimation);
    alphaAnimation =
        Tween<double>(begin: 0, end: 1).animate(controllerAnimation);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)!.settings.arguments as TreeNode?;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? Colors.white
          : Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconImageButton(
                  res: AppImages.back,
                  onClick: () {
                    Navigator.of(context).pop();
                  },
                ),
                Text(S.of(context).newFolderTwo,
                    style: const TextStyle(
                        fontWeight: FontWeight.w500, fontSize: 15)),
                Expanded(child: Container()),
                InkWell(
                  onTap: () async {
                    if (newName.isNotEmpty) {
                      selectNode.addChild(TreeNode(
                          fileType: FileType.folder,
                          info: BookmarkInfo(title: newName, url: ""),
                          children: [],
                          level: selectNode.level + 1));
                      await provider.treeNodeInfo.put();
                      Navigator.of(context).pop();
                    } else {
                      Navigator.of(context).pop();
                    }
                  },
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: Text(S.of(context).done,
                        style: const TextStyle(
                            fontWeight: FontWeight.w300, fontSize: 13)),
                  ),
                )
              ],
            ),
            const Divider(height: 2),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 5),
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: S.of(context).title,
                  border: InputBorder.none,
                  hintStyle: const TextStyle(fontSize: 15),
                ),
                maxLines: 1,
                onChanged: (value) {
                  setState(() {
                    newName = value;
                  });
                },
                style: const TextStyle(fontSize: 15),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 15, right: 15, top: 5),
              child: Divider(height: 2),
            ),
            GestureDetector(
              child: Row(
                children: [
                  const IconImageButton(res: AppImages.folder),
                  Expanded(
                      child: SizedBox(
                    height: 50,
                    child: Column(
                      children: [
                        Expanded(
                            child: Container(
                          color: Colors.transparent,
                          child: Center(
                              child: Text(selectNode.info.title,
                                  style: const TextStyle(fontSize: 13))),
                        )),
                        const Divider(height: 1)
                      ],
                    ),
                  )),
                  SizedBox(
                    height: 50,
                    width: 50,
                    child: AnimatedBuilder(
                      animation: animation,
                      builder: (context, child) {
                        return Transform.rotate(
                            angle: animation.value,
                            child: const IconImageButton(
                              res: AppImages.back,
                              rotation: -0.5,
                            ));
                      },
                    ),
                  )
                ],
              ),
              onTap: () {
                setState(() {
                  if (animation.value >= 1) {
                    controllerAnimation.reverse();
                  } else {
                    controllerAnimation.forward();
                  }
                });
              },
            ),
            const Divider(
              height: 5,
              color: Colors.transparent,
            ),
            Expanded(
                child: FadeTransition(
              opacity: alphaAnimation,
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Folder(
                    node: provider.treeNodeInfo,
                    selectNode: data ?? selectNode,
                    onClick: (node) {
                      setState(() {
                        selectNode = node;
                      });
                    }),
              ),
            ))
          ],
        ),
      ),
    );
  }
}
