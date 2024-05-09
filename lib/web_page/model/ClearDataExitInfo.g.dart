import 'package:browser01/web_page/custom/custom.dart';
import 'package:browser01/web_page/model/clear_data_exit_info.dart';
import 'package:hive/hive.dart';

class ClearDataExitAdapter extends TypeAdapter<ClearDataExitInfo> {

  @override
  ClearDataExitInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ClearDataExitInfo(
        clearName: fields[0] as String,
        name: fields[1] as String,
        isSelect: fields[2] as bool
    );
  }

  @override
  void write(BinaryWriter writer, ClearDataExitInfo obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.clearName)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.isSelect)
    ;
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ClearDataExitAdapter &&
              runtimeType == other.runtimeType &&
              typeId == other.typeId;

  @override
  int get typeId {
    return 6;
  }
}
