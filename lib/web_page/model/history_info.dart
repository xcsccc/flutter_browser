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

  const HistoryInfo({required this.title,required this.url,required this.time});

  static Box<HistoryInfo> openBox() {
    return Hive.box<HistoryInfo>(historyInfoKey);
  }

  void save() {
    openBox().add(this);
  }

  @override
  String toString() {
    return 'HistoryInfo{title: $title, url: $url, time: $time}';
  }

  static List<HistoryInfo> getAll() {
    return openBox().values.toList();
  }
}