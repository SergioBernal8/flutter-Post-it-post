import 'package:post_it_post/domain/managers/base_db_manager.dart';
import 'package:post_it_post/domain/models/post_item.dart';

class MockDBManager extends BaseDataBaseManager {
  var mockCase = MockDBManagerCase.success;
  @override
  Future<bool> deleteAllPostItems() {
    return Future.value(true);
  }

  @override
  Future<bool> deletePostItem(int postID) {
    return Future.value(true);
  }

  @override
  Future<List<PostItem>> getSavedPostItems() {
    if (mockCase == MockDBManagerCase.emptyData) {
      return Future.value([]);
    }
    final postList = List.generate(
        2,
        (index) => PostItem(
            id: index,
            title: "title",
            body: "body",
            isFavorite: 1,
            isRead: 1,
            userId: index));
    return Future.value(postList);
  }

  @override
  Future<bool> saveAllPostItems(List<PostItem> allPost) {
    return Future.value(true);
  }

  @override
  Future<bool> updatePostItem(PostItem item) {
    return Future.value(true);
  }

  @override
  closeDataBase() {}

  @override
  startDataBase() {}
}

enum MockDBManagerCase { success, emptyData }
