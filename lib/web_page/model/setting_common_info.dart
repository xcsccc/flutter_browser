import 'package:hive/hive.dart';
import '../custom/custom.dart';

@HiveType(typeId: 2)
class SettingCommonInfo{
  @HiveField(0)
  String title;
  @HiveField(1)
  String desc;
  SettingCommonInfo({required this.title,required this.desc});


  static Box<SettingCommonInfo> openBox() {
    return Hive.box<SettingCommonInfo>(settingCommonKey);
  }

  void edit(int index) {
    openBox().putAt(index, this);
  }

  static List<SettingCommonInfo> getAll() {
    return openBox().values.toList();
  }

  @override
  String toString() {
    return 'SettingCommonInfo{title: $title, desc: $desc}';
  }
}
