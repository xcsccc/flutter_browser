import 'package:hive/hive.dart';

import '../custom/custom.dart';

@HiveType(typeId: 3)
class BookmarkInfo{
  @HiveField(0)
  final String url;
  @HiveField(1)
  final String title;

  BookmarkInfo({required this.url,required this.title});


  static Box<BookmarkInfo> openBox() {
    return Hive.box<BookmarkInfo>(bookmarkInfoKey);
  }

  void save() {
    openBox().add(this);
  }

  void delete(){
    openBox().deleteAt(getAll().indexWhere((element) => element == this,-1));
  }


  @override
  String toString() {
    return 'BookmarkInfo{url: $url, title: $title}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is BookmarkInfo &&
              runtimeType == other.runtimeType &&
              title == other.title &&
              url == other.url;

  @override
  int get hashCode => title.hashCode ^ url.hashCode;

  static List<BookmarkInfo> getAll() {
    return openBox().values.toList();
  }
}