import 'package:browser01/web_page/model/history_info.dart';
import 'package:hive/hive.dart';

class HistoryInfoAdapter extends TypeAdapter<HistoryInfo> {
  @override
  final int typeId = 1;

  @override
  HistoryInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HistoryInfo(
      title: fields[0] as String,
      url: fields[1] as String,
      time: fields[2] as int,
      id: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, HistoryInfo obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.url)
      ..writeByte(2)
      ..write(obj.time)
      ..writeByte(3)
      ..write(obj.id)
    ;
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is HistoryInfoAdapter &&
              runtimeType == other.runtimeType &&
              typeId == other.typeId;
}
