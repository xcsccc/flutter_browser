import 'package:hive/hive.dart';

import '../custom/custom.dart';

@HiveType(typeId: 1)
class HistoryInfo{
  @HiveField(0)
  final String title;
  @HiveField(1)
  final String url;
  @HiveField(2)
  final int time;

  HistoryInfo({required this.title,required this.url,required this.time});

  static Box<HistoryInfo> openBox() {
    return Hive.box<HistoryInfo>(historyInfoKey);
  }

  void save() {
    openBox().add(this);
  }
  
  void delete(){
    openBox().deleteAt(getAll().indexWhere((element) => element == this,-1));
  }

  @override
  String toString() {
    return 'HistoryInfo{title: $title, url: $url, time: $time}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HistoryInfo &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          url == other.url &&
          time == other.time;

  @override
  int get hashCode => title.hashCode ^ url.hashCode ^ time.hashCode;

  static List<HistoryInfo> getAll() {
    return openBox().values.toList();
  }
}