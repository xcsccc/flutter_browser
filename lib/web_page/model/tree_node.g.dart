// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tree_node.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TreeNodeAdapter extends TypeAdapter<TreeNode> {
  @override
  final int typeId = 4;

  @override
  TreeNode read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TreeNode(
      fileType: fields[0] as FileType,
      info: fields[1] as BookmarkInfo,
      children: (fields[2] as List).cast<TreeNode>(),
      level: fields[3] as int
    );
  }

  @override
  void write(BinaryWriter writer, TreeNode obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.fileType)
      ..writeByte(1)
      ..write(obj.info)
      ..writeByte(2)
      ..write(obj.children)
      ..writeByte(3)
      ..write(obj.level)
    ;
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TreeNodeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
