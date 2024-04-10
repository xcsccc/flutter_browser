import 'package:hive/hive.dart';
import 'custom.dart';

@HiveType(typeId: 0)
class FuncBottomInfo{
  @HiveField(0)
  String iconRes;
  @HiveField(1)
  String name;
  @HiveField(2)
  bool isShow = true;
  @HiveField(3)
  int type;
  FuncBottomInfo({required this.iconRes,required this.name,required this.isShow,required this.type});


  static Box<FuncBottomInfo> openBox() {
    return Hive.box<FuncBottomInfo>(funcBottomKey);
  }

  void save() {
    openBox().add(this);
  }

  static List<FuncBottomInfo> getAll() {
    return openBox().values.toList();
  }

}
