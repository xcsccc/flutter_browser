import 'package:browser01/web_page/model/setting_common_info.dart';
import 'package:hive/hive.dart';

class SettingCommonAdapter extends TypeAdapter<SettingCommonInfo> {
  @override
  final int typeId = 2;

  @override
  SettingCommonInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SettingCommonInfo(
      title: fields[0] as String,
      desc: fields[1] as String
    );
  }

  @override
  void write(BinaryWriter writer, SettingCommonInfo obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.desc)
    ;
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is SettingCommonAdapter &&
              runtimeType == other.runtimeType &&
              typeId == other.typeId;
}
