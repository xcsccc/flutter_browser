import 'package:browser01/web_page/custom/custom.dart';
import 'package:hive/hive.dart';
import 'func_bottom_info.dart';

class FuncBottomInfoAdapter extends TypeAdapter<FuncBottomInfo> {
  @override
  final int typeId = 0;

  @override
  FuncBottomInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FuncBottomInfo(
      iconRes: fields[0] as String,
      name: fields[1] as String,
      isShow: fields[2] as bool,
      type: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, FuncBottomInfo obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.iconRes)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.isShow)
      ..writeByte(3)
      ..write(obj.type)
      ;
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FuncBottomInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
