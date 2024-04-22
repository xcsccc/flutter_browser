import 'package:browser01/web_page/model/file_type.dart';
import 'package:hive/hive.dart';
class FileTypeAdapter extends TypeAdapter<FileType> {
  @override
  final int typeId = 5;

  @override
  FileType read(BinaryReader reader) {
    return FileType.values[reader.readByte()];
  }

  @override
  void write(BinaryWriter writer, FileType obj) {
    writer.writeByte(obj.index);
  }
}
