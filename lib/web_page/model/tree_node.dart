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
  List<TreeNode> children = [];

  TreeNode({required this.fileType,required this.info});

  void addChild(TreeNode child) {
    children.add(child);
  }

  static Box<TreeNode> openBox() {
    return Hive.box<TreeNode>(treeNodeKey);
  }

  void save() {
    openBox().add(this);
  }

  void delete(){
    openBox().deleteAt(getAll().indexWhere((element) => element == this,-1));
  }


  @override
  String toString() {
    return 'TreeNode{fileType: $fileType, info: $info, children: $children}';
  }


  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TreeNode &&
          runtimeType == other.runtimeType &&
          fileType == other.fileType &&
          info == other.info &&
          children == other.children;

  @override
  int get hashCode => fileType.hashCode ^ info.hashCode ^ children.hashCode;

  static List<TreeNode> getAll() {
    return openBox().values.toList();
  }
}
