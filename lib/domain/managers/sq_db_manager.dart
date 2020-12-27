import 'package:path/path.dart';
import 'package:post_it_post/domain/managers/base_db_manager.dart';
import 'package:post_it_post/domain/models/post_item.dart';
import 'package:sqflite/sqflite.dart';

const String DB_NAME = "post_it_post.db";

class SQDBManager extends BaseDataBaseManager {
  final int dbVersion = 1;
  Database db;

  startDataBase() async {
    if (db == null) {
      var databasePath = await getDatabasesPath();
      String path = join(databasePath, DB_NAME);
      db =
          await openDatabase(path, version: dbVersion, onCreate: _createTables);
    }
  }

  _createTables(Database database, int version) async {
    await database
        .execute("CREATE TABLE IF NOT EXISTS ${_TableNames.POST_ITEM} ("
            "id INTEGER PRIMARY KEY,"
            "userId INTEGER,"
            "title TEXT,"
            "body TEXT,"
            "isRead INTEGER,"
            "isFavorite INTEGER"
            ")");
  }

  @override
  Future<bool> deleteAllPostItems() async {
    return await db.delete(_TableNames.POST_ITEM) > 0;
  }

  @override
  Future<List<PostItem>> getSavedPostItems() async {
    var query = await db.rawQuery("SELECT * FROM ${_TableNames.POST_ITEM}");
    return query.toList().map((e) => PostItem.fromJson(e)).toList();
  }

  @override
  Future<bool> updatePostItem(PostItem item) async {
    return await db.update(_TableNames.POST_ITEM, item.toMap(),
            where: "id = ?", whereArgs: [item.id]) >
        0;
  }

  @override
  Future<bool> saveAllPostItems(List<PostItem> allPost) async {
    allPost?.forEach((postItem) async {
      await db
          .insert(_TableNames.POST_ITEM, postItem.toMap())
          .catchError((error) {
        return false;
      });
    });
    return true;
  }

  @override
  Future<bool> deletePostItem(int postID) async {
    return await db.delete(_TableNames.POST_ITEM,
            where: 'id = ?', whereArgs: [postID]) >
        0;
  }

  @override
  closeDataBase() async {
    await db.close();
    db = null;
  }
}

class _TableNames {
  static const String POST_ITEM = "PostItem";
}
