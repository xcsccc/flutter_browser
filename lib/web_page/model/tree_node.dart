import 'package:browser01/web_page/custom/custom.dart';
import 'package:browser01/web_page/model/bookmark_info.dart';
import 'package:hive/hive.dart';
import 'file_type.dart';
part 'tree_node.g.dart';

@HiveType(typeId: 4)
class TreeNode{
  @HiveField(0)
  FileType fileType;
  @HiveField(1)
  BookmarkInfo info;
  @HiveField(2)
  List<TreeNode> children;
  @HiveField(3)
  //0 1 2 3 4 5 6 ...
  int level;

  bool select = false;

  TreeNode({required this.fileType,required this.info,required this.children,required this.level});

  void addChild(TreeNode child) {
    if(child.fileType == FileType.folder && children.contains(child)){
      return;
    }
    children.add(child);
  }

  static Box<TreeNode> openBox() {
    return Hive.box<TreeNode>(treeNodeKey);
  }

  Future<void> put() async {
    await openBox().put(treeNodeInfoKey,this);
  }

  static TreeNode get(){
    return openBox().get(treeNodeInfoKey,defaultValue: TreeNode(
    fileType: FileType.folder,
        info: BookmarkInfo(title: 'Root folder', url: ""),children:[], level: 0),)!;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TreeNode &&
          runtimeType == other.runtimeType &&
          fileType == other.fileType &&
          info == other.info &&
          children == other.children &&
          level == other.level;

  @override
  int get hashCode =>
      fileType.hashCode ^ info.hashCode ^ children.hashCode ^ level.hashCode;

  @override
  String toString() {
    return 'TreeNode{fileType: $fileType, info: $info, children: $children, level: $level, select: $select}';
  }
}
