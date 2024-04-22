import 'package:hive/hive.dart';

@HiveType(typeId: 5)
enum FileType{
  @HiveField(0)
  folder,
  @HiveField(1)
  bookmark,
  none
}