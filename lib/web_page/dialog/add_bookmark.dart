import 'package:browser01/web_page/custom/image_path.dart';
import 'package:browser01/web_page/dialog/long_click_dialog.dart';
import 'package:browser01/web_page/model/bookmark_info.dart';
import 'package:browser01/web_page/model/file_type.dart';
import 'package:browser01/web_page/now_icon.dart';
import 'package:browser01/web_page/provider/main_provider.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../generated/l10n.dart';
import '../color/colors.dart';
import '../model/tree_node.dart';

void showAddBookmarkDialog(BuildContext context, BookmarkInfo info) {
  showDialog(
      context: context,
      builder: (context) {
        return AddBookmarkDialog(info: info);
      });
}

class AddBookmarkDialog extends StatefulWidget {
  final BookmarkInfo info;

  const AddBookmarkDialog({super.key, required this.info});

  @override
  State<StatefulWidget> createState() => AddBookmarkState();
}

class AddBookmarkState extends State<AddBookmarkDialog> {
  late TextEditingController controller =
      TextEditingController(text: widget.info.title);
  late TextEditingController controller2 =
      TextEditingController(text: widget.info.url);
  late TextEditingController controllerNewFolder = TextEditingController();
  late String title = widget.info.title;
  late String url = widget.info.url;
  late GlobalProvider provider = Provider.of<GlobalProvider>(context);
  late String folderName = provider.treeNodeInfo.info.title;
  late TextEditingController controller3 =
      TextEditingController(text: folderName);
  PageController pageController = PageController(initialPage: 0);
  String newFolderName = "";
  bool isCheck = false;
  bool newFolder = false;
  late TreeNode historyNode = provider.treeNodeInfo;
  late TreeNode selectNode = historyNode;

  Widget onePage() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(S.of(context).addBookmark,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
        Container(height: 10),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: S.of(context).title,
            border: InputBorder.none,
            hintStyle: const TextStyle(fontSize: 15),
          ),
          maxLines: 1,
          onChanged: (value) {
            setState(() {
              title = value;
            });
          },
          style: const TextStyle(fontSize: 15),
        ),
        const Divider(
          height: 1,
        ),
        Container(height: 10),
        TextField(
          controller: controller2,
          decoration: InputDecoration(
            hintText: S.of(context).url,
            border: InputBorder.none,
            hintStyle: const TextStyle(fontSize: 15),
          ),
          maxLines: 1,
          onChanged: (value) {
            setState(() {
              url = value;
            });
          },
          style: const TextStyle(fontSize: 15),
        ),
        const Divider(
          height: 1,
        ),
        Container(height: 10),
        TextField(
          controller: controller3,
          readOnly: true,
          decoration: InputDecoration(
            hintText: S.of(context).title,
            border: InputBorder.none,
            hintStyle: const TextStyle(fontSize: 15),
          ),
          style: const TextStyle(fontSize: 15),
          onTap: () {
            pageController.animateToPage(1,
                duration: const Duration(milliseconds: 200),
                curve: Curves.fastEaseInToSlowEaseOut);
          },
        ),
        const Divider(
          height: 1,
        ),
        Container(height: 10),
        Row(
          children: [
            Checkbox(
                value: isCheck,
                onChanged: (check) {
                  setState(() {
                    isCheck = check!;
                  });
                }),
            GestureDetector(
              onTap: () {
                setState(() {
                  isCheck = !isCheck;
                });
              },
              child: Text(S.of(context).addHomepage,
                  style: const TextStyle(fontSize: 13)),
            )
          ],
        ),
        Container(height: 25),
        Align(
          alignment: Alignment.centerRight,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  S.of(context).cancel,
                  style: TextStyle(
                      fontSize: 15, color: ThemeColors.progressStartColor),
                ),
              ),
              Container(
                width: 20,
              ),
              GestureDetector(
                onTap: () async {
                  if (controller.text.isNotEmpty &&
                      controller2.text.isNotEmpty) {
                    //添加到书签
                    selectNode.addChild(TreeNode(
                        fileType: FileType.bookmark,
                        info: BookmarkInfo(title: title, url: url),
                        children: [],
                        level: selectNode.level + 1));
                    await historyNode.put();
                    Navigator.of(context).pop();
                  } else {
                    toastMsg(S.of(context).msgEmpty);
                  }
                },
                child: Text(
                  S.of(context).ok,
                  style: TextStyle(
                      fontSize: 15, color: ThemeColors.progressStartColor),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget twoPage() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconImageButton(
              res: AppImages.back,
              onClick: () {
                pageController.animateToPage(0,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.fastEaseInToSlowEaseOut);
              },
            ),
            Container(
              width: 20,
            ),
            Text(S.of(context).selectFolder,
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
            Expanded(child: Container()),
            IconImageButton(
              res: newFolder ? AppImages.close : AppImages.add,
              onClick: () {
                setState(() {
                  newFolder = !newFolder;
                });
              },
            )
          ],
        ),
        if (newFolder)
          Row(
            children: [
              const IconImageButton(res: AppImages.folderAdd),
              Expanded(
                child: TextField(
                  controller: controllerNewFolder,
                  decoration: InputDecoration(
                    hintText: S.of(context).newFolder,
                    border: InputBorder.none,
                    hintStyle: const TextStyle(fontSize: 15),
                  ),
                  maxLines: 1,
                  onChanged: (value) {
                    setState(() {
                      newFolderName = value;
                    });
                  },
                  style: const TextStyle(fontSize: 15),
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (newFolderName.isNotEmpty) {
                    //添加文件夹
                    setState(() {
                      selectNode.addChild(TreeNode(
                          fileType: FileType.folder,
                          info: BookmarkInfo(title: newFolderName, url: ""),
                          children: [],
                          level: selectNode.level + 1));
                    });

                    pageController.animateToPage(0,
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.fastEaseInToSlowEaseOut);

                    setState(() {
                      controllerNewFolder.text = "";
                      newFolder = false;
                    });
                  } else {
                    toastMsg(S.of(context).msgEmpty);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    S.of(context).ok,
                    style: TextStyle(
                        fontSize: 15, color: ThemeColors.progressStartColor),
                  ),
                ),
              ),
            ],
          ),
        Folder(
          node: historyNode,
          selectNode: selectNode,
          onClick: (select) {
            selectNode = select;
            setState(() {
              controller3.text = selectNode.info.title;
              setState(() {
                controllerNewFolder.text = "";
                newFolder = false;
              });
            });
            pageController.animateToPage(0,
                duration: const Duration(milliseconds: 200),
                curve: Curves.fastEaseInToSlowEaseOut);
          },
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomBaseDialog(
        child: ExpandablePageView(
      controller: pageController,
      physics: const NeverScrollableScrollPhysics(),
      children: [onePage(), twoPage()],
    ));
  }
}

class Folder extends StatefulWidget {
  final TreeNode node;
  final TreeNode selectNode;
  final Function(TreeNode select) onClick;

  const Folder(
      {super.key,
      required this.node,
      required this.selectNode,
      required this.onClick});

  @override
  State<StatefulWidget> createState() => FolderState();
}

class FolderState extends State<Folder> {
  Widget? getFolder(TreeNode node) {
    if (node.fileType == FileType.folder) {
      List<Widget> widgets = [];
      for (TreeNode node in node.children) {
        var folder = getFolder(node);
        if (folder != null) {
          widgets.add(folder);
        }
      }
      return Column(mainAxisSize: MainAxisSize.min, children: [
        Container(
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              color: node == widget.selectNode
                  ? ThemeColors.borderColor
                  : Colors.transparent),
          child: InkWell(
            onTap: () {
              widget.onClick(node);
            },
            borderRadius:  const BorderRadius.all(Radius.circular(15)),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: node.level * 10),
                  child: const IconImageButton(res: AppImages.folder),
                ),
                Container(
                  width: 20,
                ),
                Expanded(
                    child: Text(node.info.title,
                        style: const TextStyle(fontSize: 13)))
              ],
            ),
          ),
        ),
        ...widgets
      ]);
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 300),
      child: SingleChildScrollView(
        child: getFolder(widget.node) ?? Container(),
      ),
    );
  }
}
