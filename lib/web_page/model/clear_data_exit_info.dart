import 'package:hive/hive.dart';

import '../custom/custom.dart';

@HiveType(typeId: 6)
class ClearDataExitInfo{
  @HiveField(0)
  String clearName;
  @HiveField(1)
  String name;
  @HiveField(2)
  bool isSelect = false;
  ClearDataExitInfo({required this.clearName,required this.name,required this.isSelect});

  static Box<ClearDataExitInfo> openBox() {
    return Hive.box<ClearDataExitInfo>(clearDataExitInfoKey);
  }

  void edit(int index) {
    openBox().putAt(index, this);
  }

  void save() {
    openBox().add(this);
  }

  static List<ClearDataExitInfo> getAll() {
    return openBox().values.toList();
  }

  @override
  String toString() {
    return 'ClearDataExitInfo{clearName: $clearName, name: $name, isSelect: $isSelect}';
  }
}