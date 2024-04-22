import 'package:browser01/web_page/model/bookmark_info.dart';
import 'package:hive/hive.dart';

class BookmarkInfoAdapter extends TypeAdapter<BookmarkInfo> {
  @override
  final int typeId = 3;

  @override
  BookmarkInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BookmarkInfo(
      title: fields[0] as String,
      url: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, BookmarkInfo obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.url)
    ;
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is BookmarkInfoAdapter &&
              runtimeType == other.runtimeType &&
              typeId == other.typeId;
}
